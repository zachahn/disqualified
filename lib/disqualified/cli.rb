# typed: strict

class Disqualified::CLI
  extend T::Sig
  include Disqualified::Logging

  sig { void }
  def self.run
    cli = new(ARGV)
    cli.run
  end

  class ServerEngine < Rails::Engine
    config.before_initialize do
      Disqualified.server_options = Disqualified::ServerConfiguration.new
    end
  end

  sig { params(argv: T::Array[String]).void }
  def initialize(argv)
    @original_argv = argv
  end

  sig { void }
  def run
    require File.join(Dir.pwd, "config/environment")

    option_parser.parse(@original_argv)

    Disqualified.server_options.to_h => {delay_range:, error_hooks:, logger:, pool_size:}

    logger.info { '    ____  _                        ___ _____          __' }
    logger.info { '   / __ \(_)________ ___  ______ _/ (_) __(_)__  ____/ /' }
    logger.info { '  / / / / / ___/ __ `/ / / / __ `/ / / /_/ / _ \/ __  /' }
    logger.info { ' / /_/ / (__  ) /_/ / /_/ / /_/ / / / __/ /  __/ /_/ /' }
    logger.info { '/_____/_/____/\__, /\__,_/\__,_/_/_/_/ /_/\___/\__,_/' }
    logger.info { '                /_/' + "v#{Disqualified::VERSION}".rjust(32, " ") }
    logger.info { Disqualified.server_options.to_s }

    pool = Disqualified::Pool.new(delay_range:, pool_size:, error_hooks:, logger:) do |args|
      args => {promise_index:}
      logger.debug { format_log("Disqualified::CLI#run <block>", "##{promise_index}") }
      Disqualified::Main.new(error_hooks:, logger:).call
    end
    pool.run!
  rescue Interrupt
    pool&.shutdown
    puts
    puts "Gracefully quitting..."
  end

  private

  sig { returns(OptionParser) }
  def option_parser
    return T.must(@option_parser) if instance_variable_defined?(:@option_parser)

    option_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename($0)} [OPTIONS]"

      server_options = T.must(Disqualified.server_options)

      opts.on("--delay-low SECONDS", Numeric, "Default: #{server_options.delay_low}") do |value|
        server_options.delay_low = value
      end

      opts.on("--delay-high SECONDS", Numeric, "Default: #{server_options.delay_high}") do |value|
        server_options.delay_high = value
      end

      opts.on("--pool COUNT", Integer, "Default: #{server_options.pool_size}") do |value|
        server_options.pool_size = value
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    @option_parser ||= T.let(option_parser, T.nilable(OptionParser))
  end
end
