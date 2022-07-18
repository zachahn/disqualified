module Disqualified
  class << self
    attr_accessor :server_options
  end

  def self.configure_server
    if server_options
      yield server_options
    end
  end
end

class Disqualified::ServerConfiguration
  def initialize
    self.delay_high = 5.0
    self.delay_low = 1.0
    self.logger = Rails.logger
    self.pool_size = 5
    self.pwd = Dir.pwd
    self.error_hooks = []
  end

  attr_accessor :delay_high
  attr_accessor :delay_low
  attr_accessor :error_hooks
  attr_accessor :logger
  attr_accessor :pool_size
  attr_accessor :pwd

  private :error_hooks=

  def delay_range
    delay_low.to_f..delay_high.to_f
  end

  def on_error(&block)
    error_hooks.push(block)
  end

  def to_h
    {
      delay_high:,
      delay_low:,
      delay_range:,
      error_hooks:,
      logger:,
      pool_size:,
      pwd:
    }
  end

  def to_s
    "{ delay: #{delay_range}, pool_size: #{pool_size}, error_hooks_size: #{error_hooks.size} }"
  end
end
