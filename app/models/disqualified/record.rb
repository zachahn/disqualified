# typed: strict

class Disqualified::Record < Disqualified::BaseRecord
  extend T::Sig

  self.table_name = "disqualified_jobs"

  serialize :metadata, JSON

  scope :runnable, -> { where(finished_at: nil, run_at: (..Time.now), locked_by: nil) }

  sig do
    params(
      block: T.nilable(T.proc.params(arg0: ActiveRecord::Relation).returns(ActiveRecord::Relation))
    ).returns(Disqualified::Record)
  end
  def self.claim_one!(&block)
    run_id = SecureRandom.uuid
    base_association =
      Disqualified::Record
        .runnable
        .order(run_at: :asc)
        .limit(1)

    association =
      if block
        yield base_association
      else
        base_association
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

  sig do
    params(
      identifier: T.any(Integer, String, Disqualified::Record)
    ).returns(Disqualified::Record)
  end
  def self.claim!(identifier)
    id =
      case identifier
      when Integer
        identifier
      when String
        Integer(identifier)
      when Disqualified::Record
        identifier.id
      else
        T.absurd(identifier)
      end

    claim_one! do |association|
      association.where(id:)
    end
  end

  sig { returns(Disqualified::Record) }
  def run!
    record = self.class.claim!(self)
    record.send(:instantiate_handler_and_perform_with_args)
    record.finish
    record
  end

  sig { void }
  def finish
    if metadata&.key?(Disqualified::Unique::RECORD_METADATA_KEY)
      unique_key = metadata.fetch(Disqualified::Unique::RECORD_METADATA_KEY)
      value = metadata.fetch(Disqualified::Unique::RECORD_METADATA_VALUE)
      Disqualified::Internal.where(unique_key:, value:).delete_all
    end

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

  sig { void }
  private def instantiate_handler_and_perform_with_args
    raise Disqualified::Error::JobAlreadyFinished if !finished_at.nil?
    raise Disqualified::Error::JobNotClaimed if locked_by.nil?

    job_class = handler.constantize
    parsed_arguments = JSON.parse(arguments)
    job = job_class.new
    job.perform(*parsed_arguments)
  end
end
