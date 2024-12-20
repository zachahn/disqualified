# typed: strict

class Disqualified::Main
  extend T::Sig
  include Disqualified::Logging

  sig { params(error_hooks: T::Array[Disqualified::Logging::ERROR_HOOK_TYPE], logger: T.untyped).void }
  def initialize(error_hooks:, logger:)
    @error_hooks = error_hooks
    @logger = logger
  end

  sig { void }
  def call
    Rails.application.reloader.wrap do
      record = Disqualified::Record.claim_one!
      run_id = record.locked_by
      record.send(:instantiate_handler_and_perform_with_args)
      record.finish
      @logger.info do
        format_log("Disqualified::Main#call", "Runner #{run_id}", "Done")
      end
    rescue Disqualified::Error::NoClaimableJob
      @logger.warn do
        format_log("Disqualified::Main#call", "No claimable jobs")
      end
    rescue => e
      record = T.must(record)
      handle_error(@error_hooks, e, {record: record.attributes})
      @logger.error { format_log("Disqualified::Main#run", "Runner #{run_id}", "Rescued Record ##{record.id}") }
      record.requeue
    end
  end
end
