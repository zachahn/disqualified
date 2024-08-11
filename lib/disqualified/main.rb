class Disqualified::Main
  include Disqualified::Logging

  def initialize(error_hooks:, logger:)
    @error_hooks = error_hooks
    @logger = logger
  end

  def call
    Rails.application.reloader.wrap do
      begin
        record = Disqualified::Record.claim_one!
        run_id = record.locked_by
      rescue ActiveRecord::RecordNotFound
        @logger.warn do
          format_log("Disqualified::Main#call", "Job not found")
        end
        next
      end

      begin
        record.send(:instantiate_handler_and_perform_with_args)
        record.finish

        @logger.info do
          format_log("Disqualified::Main#call", "Runner #{run_id}", "Done")
        end
      rescue => e
        handle_error(@error_hooks, e, {record: record.attributes})
        @logger.error { format_log("Disqualified::Main#run", "Runner #{run_id}", "Rescued Record ##{record.id}") }
        record.requeue
      end
    end
  end
end
