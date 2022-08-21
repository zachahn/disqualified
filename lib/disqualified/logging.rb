module Disqualified::Logging
  module_function

  def format_log(*parts)
    *extras, message = parts

    if extras.empty?
      message
    else
      "#{extras.map { |x| "[#{x}]" }.join(" ")} #{message}"
    end
  end

  def handle_error(error_hooks, error, context)
    error_hooks.each do |hook|
      hook.call(error, context)
    rescue
      nil
    end
  end
end
