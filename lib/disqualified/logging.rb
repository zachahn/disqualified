module Disqualified::Logging
  module_function

  def format_log(message)
    "[#{Time.now.iso8601(3)}] #{message}"
  end
end
