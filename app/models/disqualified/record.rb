class Disqualified::Record < Disqualified::BaseRecord
  self.table_name = "disqualified_jobs"

  belongs_to :disqualified_sequence,
    class_name: "Disqualified::SequenceRecord",
    foreign_key: "sequence_uuid",
    primary_key: "uuid",
    optional: true

  scope :with_sequence, -> {
    joins("LEFT OUTER JOIN disqualified_sequences ds ON ds.uuid = sequence_uuid AND ds.current_step = sequence_step")
      .where("ds.uuid = sequence_uuid OR (ds.uuid IS NULL AND sequence_uuid IS NULL)")
  }
  scope :pending, -> { where(finished_at: nil, run_at: (..Time.now), locked_by: nil) }
  scope :runnable, -> { with_sequence.pending }

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

    raise Disqualified::Error::NoClaimableJob if claimed_count == 0

    Disqualified::Record.find_by!(locked_by: run_id)
  rescue ActiveRecord::RecordNotFound
    raise Disqualified::Error::NoClaimableJob
  end

  def run!
    record = self.class.claim_one!(id:)
    begin
      record.send(:instantiate_handler_and_perform_with_args)
    rescue => e
      record.unclaim
      raise e
    else
      record.finish
    end
    record
  end

  def finish
    transaction do
      update!(locked_by: nil, locked_at: nil, finished_at: Time.now)
      if sequence_uuid && sequence_step
        Disqualified::SequenceRecord
          .where(uuid: sequence_uuid, current_step: sequence_step)
          .update_all(
            current_step: sequence_step + 1,
            updated_at: Time.now
          )
      end
    end
  end

  def requeue
    retry_count = attempts - 1
    sleep = (retry_count**4) + 15 + (rand(10) * (retry_count + 1))
    unclaim(next_run_at: Time.now + sleep)
  end

  def unclaim(next_run_at: nil)
    if next_run_at
      update!(locked_by: nil, locked_at: nil, run_at: next_run_at)
    else
      update!(locked_by: nil, locked_at: nil)
    end
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
