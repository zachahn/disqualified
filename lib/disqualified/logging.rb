module Disqualified::Logging
  ERROR_CONTEXT_TYPE = T.type_alias do
    T::Hash[T.untyped, T.untyped]
  end

  ERROR_HOOK_TYPE = T.type_alias do
    T.proc.params(arg0: Exception, arg1: ERROR_CONTEXT_TYPE).void
  end

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
