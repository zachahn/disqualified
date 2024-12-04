# typed: strict

class Disqualified::Server
  extend T::Sig
  include Disqualified::Logging

  sig { params(server_options: Disqualified::ServerConfiguration).void }
  def initialize(server_options)
    @server_options = server_options
  end

  sig { returns(Disqualified::ServerConfiguration) }
  attr_reader :server_options

  sig { void }
  def run
    delay_range = server_options.delay_range
    error_hooks = server_options.error_hooks
    logger = server_options.logger
    pool_size = server_options.pool_size

    # standard:disable Style/StringLiterals
    logger.info { '    ____  _                        ___ _____          __' }
    logger.info { '   / __ \(_)________ ___  ______ _/ (_) __(_)__  ____/ /' }
    logger.info { '  / / / / / ___/ __ `/ / / / __ `/ / / /_/ / _ \/ __  /' }
    logger.info { ' / /_/ / (__  ) /_/ / /_/ / /_/ / / / __/ /  __/ /_/ /' }
    logger.info { '/_____/_/____/\__, /\__,_/\__,_/_/_/_/ /_/\___/\__,_/' }
    logger.info { '                /_/' + "v#{Disqualified::VERSION}".rjust(32, " ") }
    # standard:enable Style/StringLiterals
    logger.info { Disqualified.server_options.to_s }

    pool = Disqualified::Pool.new(delay_range:, pool_size:, error_hooks:, logger:) do |args|
      args => {promise_index:}
      logger.debug { format_log("Disqualified::CLI#run <block>", "##{promise_index}") }
      Disqualified::Main.new(error_hooks:, logger:).call
    end
    pool.run!
  rescue Interrupt
    puts
    puts "Gracefully quitting..."
    pool&.shutdown
    puts "Bye!"
  end
end
