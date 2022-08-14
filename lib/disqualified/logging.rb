module Disqualified::Logging
  module_function

  def format_log(message)
    "[#{Time.now.iso8601(3)}] #{message}"
  end

  def handle_error(error_hooks, error, context)
    error_hooks.each do |hook|
      hook.call(error, context)
    rescue
      nil
    end
  end
end
