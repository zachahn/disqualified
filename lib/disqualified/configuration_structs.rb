class Disqualified::ClientConfiguration
  def initialize
    @enqueue_after_transaction_commit = false
  end

  attr_accessor :enqueue_after_transaction_commit
end

class Disqualified::ServerConfiguration
  def initialize
    @delay_high = 5.0
    @delay_low = 1.0
    @logger = Rails.logger
    @pool_size = 5
    @pwd = Dir.pwd
    @error_hooks = []
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

  def to_s
    "{ delay: #{delay_range}, pool_size: #{pool_size}, error_hooks_size: #{error_hooks.size} }"
  end
end
