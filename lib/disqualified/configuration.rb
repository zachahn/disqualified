# typed: strict

module Disqualified
  extend T::Sig

  @client_options = T.let(ClientConfiguration.new, ClientConfiguration)

  class << self
    extend T::Sig

    sig { returns(Disqualified::ClientConfiguration) }
    attr_accessor :client_options

    sig { returns(T.nilable(Disqualified::ServerConfiguration)) }
    attr_accessor :server_options

    sig { params(block: T.proc.params(arg0: Disqualified::ClientConfiguration).void).void }
    def configure_client(&block)
      block.call(client_options)
    end

    # While client options are always run, server options only run in the "disqualified" process
    sig { params(block: T.proc.params(arg0: Disqualified::ServerConfiguration).void).void }
    def configure_server(&block)
      if server_options
        block.call(T.must(server_options))
      end
    end
  end
end
