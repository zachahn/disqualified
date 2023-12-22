# typed: strict

module Disqualified
  extend T::Sig

  class << self
    extend T::Sig

    sig { params(config: Disqualified::Configuration).returns(Disqualified::Configuration) }
    attr_writer :config

    sig { returns(Disqualified::Configuration) }
    def config
      @config ||= T.let(Disqualified::Configuration.new, T.nilable(Disqualified::Configuration))
    end

    sig { params(block: T.proc.params(arg0: Disqualified::Configuration).void).void }
    def configure(&block)
      block.call(config)
    end
  end
end

class Disqualified::Configuration
  extend T::Sig

  sig { void }
  def initialize
    @delay_high = T.let(5.0, Numeric)
    @delay_low = T.let(1.0, Numeric)
    @logger = T.let(Rails.logger, T.untyped)
    @pool_size = T.let(5, Integer)
    @pwd = T.let(Dir.pwd, String)
    @error_hooks = T.let([], T::Array[Disqualified::Logging::ERROR_HOOK_TYPE])
    @plugins = T.let(Disqualified::PluginRegistry.new, Disqualified::PluginRegistry)

    plugins.register(Disqualified::Unique::Plugin.new)
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
  sig { returns(Disqualified::PluginRegistry) }
  attr_accessor :plugins

  private :error_hooks=
  private :plugins=

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
