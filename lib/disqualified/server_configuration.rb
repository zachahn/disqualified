# typed: strict

module Disqualified
  extend T::Sig

  class << self
    extend T::Sig

    sig { returns(T.nilable(Disqualified::ServerConfiguration)) }
    attr_accessor :server_options

    sig { params(block: T.proc.params(arg0: Disqualified::ServerConfiguration).void).void }
    def configure_server(&block)
      if server_options
        block.call(T.must(server_options))
      end
    end
  end
end

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
    @queues = T.let([], T::Array[Symbol])
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
  sig { returns(T::Array[Symbol]) }
  attr_accessor :queues

  private :error_hooks=
  private :queues=

  sig { returns(T::Range[Float]) }
  def delay_range
    delay_low.to_f..delay_high.to_f
  end

  sig { params(block: Disqualified::Logging::ERROR_HOOK_TYPE).void }
  def on_error(&block)
    error_hooks.push(block)
  end

  sig { params(queue: T.any(String, Symbol)).void }
  def specify_queue(queue)
    queues.push(queue.to_sym)
  end

  sig { returns(String) }
  def queues_to_s
    if queues.empty?
      "ALL_QUEUES"
    else
      "[#{queues.join(", ")}]"
    end
  end

  sig { returns(String) }
  def to_s
    "{ delay: #{delay_range}, pool_size: #{pool_size}, error_hooks_size: #{error_hooks.size}, queues: #{queues_to_s} }"
  end
end
