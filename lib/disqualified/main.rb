class Disqualified::Main
  include Disqualified::Logging

  def initialize(error_hooks:, logger:)
    @error_hooks = error_hooks
    @logger = logger
  end

  def call
    run_id = SecureRandom.uuid

    Rails.application.executor.wrap do
      # Claim a job
      claimed_count =
        Disqualified::Record
          .where(finished_at: nil, run_at: (..Time.now), locked_by: nil)
          .order(run_at: :asc)
          .limit(1)
          .update_all(locked_by: run_id, locked_at: Time.now, updated_at: Time.now, attempts: Arel.sql("attempts + 1"))

      @logger.debug { format_log("[Disqualified::Main#run] [Runner #{run_id}] Claimed #{claimed_count}") }

      next if claimed_count == 0

      # Find the job that we claimed; quit early if none was claimed
      job = Disqualified::Record.find_by!(locked_by: run_id)

      begin
        # Deserialize job
        handler_class = job.handler.constantize
        arguments = JSON.parse(job.arguments)

        begin
          @logger.info do
            format_log("[#{run_id}] Running `#{job.handler}' with #{arguments.size} argument(s)")
          end
        rescue
          nil
        end

        # Run the job
        handler = handler_class.new
        handler.perform(*arguments)

        finish(job)

        begin
          @logger.info do
            format_log("[#{run_id}] Done")
          end
        rescue
          nil
        end
      rescue => e
        @error_hooks.each do |hook|
          hook.call(e)
        rescue
          nil
        end
        @logger.error { format_log("[Disqualified::Main#run] [Runner #{run_id}] Rescued Record ##{job&.id}") }
        requeue(job)
      end
    end
  end

  private

  def finish(job)
    job.update!(locked_by: nil, locked_at: nil, finished_at: Time.now)
  end

  def requeue(job)
    # Formula from the Sidekiq wiki
    retry_count = job.attempts - 1
    sleep = (retry_count**4) + 15 + (rand(10) * (retry_count + 1))
    @logger.error { format_log("[Disqualified::Main#requeue] Sleeping job for ##{sleep} seconds") }
    job.update!(locked_by: nil, locked_at: nil, run_at: Time.now + sleep)
  end
end
