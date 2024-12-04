# typed: strict

class Disqualified::CLI
  extend T::Sig

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

    server_options = T.must(Disqualified.server_options)
    server = Disqualified::Server.new(server_options)
    server.run
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
