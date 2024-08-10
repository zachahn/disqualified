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
