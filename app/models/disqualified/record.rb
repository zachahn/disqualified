# typed: strict

class Disqualified::Record < Disqualified::BaseRecord
  extend T::Sig

  self.table_name = "disqualified_jobs"

  sig { returns(Disqualified::Record) }
  def self.claim_one!
    run_id = SecureRandom.uuid

    claimed_count =
      Disqualified::Record
        .where(finished_at: nil, run_at: (..Time.now), locked_by: nil)
        .order(run_at: :asc)
        .limit(1)
        .update_all(locked_by: run_id, locked_at: Time.now, updated_at: Time.now, attempts: Arel.sql("attempts + 1"))

    raise ActiveRecord::RecordNotFound if claimed_count == 0

    Disqualified::Record.find_by!(locked_by: run_id)
  end

  sig { void }
  def run_claimed
    job_class = handler.constantize
    parsed_arguments = JSON.parse(arguments)
    job = job_class.new
    job.perform(*parsed_arguments)
  end

  sig { void }
  def finish
    update!(locked_by: nil, locked_at: nil, finished_at: Time.now)
  end

  sig { void }
  def requeue
    retry_count = attempts - 1
    sleep = (retry_count**4) + 15 + (rand(10) * (retry_count + 1))
    unqueue(run_at: Time.now + sleep)
  end

  sig { params(run_at: T.nilable(Time)).void }
  def unqueue(run_at: nil)
    run_at ||= Time.now
    update!(locked_by: nil, locked_at: nil, run_at:)
  end
end
