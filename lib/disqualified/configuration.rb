module Disqualified
  @client_options = ClientConfiguration.new

  class << self
    attr_accessor :client_options

    attr_accessor :server_options

    def configure_client(&block)
      block.call(client_options)
    end

    # While client options are always run, server options only run in the "disqualified" process

    def configure_server(&block)
      if server_options
        block.call(server_options)
      end
    end
  end
end
