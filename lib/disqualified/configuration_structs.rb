# typed: strict

class Disqualified::ServerConfiguration
  extend T::Sig

  sig { void }
  def initialize
    @delay_high = T.let(5.0, Numeric)
    @delay_low = T.let(1.0, Numeric)
    @logger = T.let(Rails.logger, T.untyped)
    @pool_size = T.let(5, Integer)
    @pwd = T.let(Dir.pwd, String)
    @error_hooks = T.let([], T::Array[Disqualified::Logging::ERROR_HOOK_TYPE])
  end

  sig { returns(Numeric) }
  attr_accessor :delay_high
  sig { returns(Numeric) }
  attr_accessor :delay_low
  sig { returns(T::Array[Disqualified::Logging::ERROR_HOOK_TYPE]) }
  attr_accessor :error_hooks
  sig { returns(T.untyped) }
  attr_accessor :logger
  sig { returns(Integer) }
  attr_accessor :pool_size
  sig { returns(String) }
  attr_accessor :pwd

  private :error_hooks=

  sig { returns(T::Range[Float]) }
  def delay_range
    delay_low.to_f..delay_high.to_f
  end

  sig { params(block: Disqualified::Logging::ERROR_HOOK_TYPE).void }
  def on_error(&block)
    error_hooks.push(block)
  end

  sig { returns(String) }
  def to_s
    "{ delay: #{delay_range}, pool_size: #{pool_size}, error_hooks_size: #{error_hooks.size} }"
  end
end
