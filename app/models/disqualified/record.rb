class Disqualified::Record < Disqualified::BaseRecord
  self.table_name = "disqualified_jobs"

  scope :runnable, -> { where(finished_at: nil, run_at: (..Time.now), locked_by: nil) }

  def self.claim_one!(id: nil)
    run_id = SecureRandom.uuid
    association =
      Disqualified::Record
        .runnable
        .order(run_at: :asc)
        .limit(1)

    if id
      association = association.where(id:)
    end

    claimed_count = association.update_all(
      locked_by: run_id,
      locked_at: Time.now,
      updated_at: Time.now,
      attempts: Arel.sql("attempts + 1")
    )

    raise ActiveRecord::RecordNotFound if claimed_count == 0

    Disqualified::Record.find_by!(locked_by: run_id)
  end

  def run!
    record = self.class.claim_one!(id:)
    record.send(:instantiate_handler_and_perform_with_args)
    record.finish
    record
  end

  def finish
    update!(locked_by: nil, locked_at: nil, finished_at: Time.now)
  end

  def requeue
    retry_count = attempts - 1
    sleep = (retry_count**4) + 15 + (rand(10) * (retry_count + 1))
    unqueue(run_at: Time.now + sleep)
  end

  def unqueue(run_at: nil)
    run_at ||= Time.now
    update!(locked_by: nil, locked_at: nil, run_at:)
  end

  private def instantiate_handler_and_perform_with_args
    raise Disqualified::Error::JobAlreadyFinished if !finished_at.nil?
    raise Disqualified::Error::JobNotClaimed if locked_by.nil?

    job_class = handler.constantize
    parsed_arguments = JSON.parse(arguments)
    job = job_class.new
    job.perform(*parsed_arguments)
  end
end
