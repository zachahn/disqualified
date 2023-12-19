# typed: strict

class Disqualified::Unique
  extend T::Sig

  RECORD_METADATA_KEY = "UNIQUE_JOB_KEY"
  RECORD_METADATA_VALUE = "UNIQUE_JOB_VALUE"

  INCL_ARGUMENTS = :arguments

  sig { params(till: Symbol, including: T.any(Symbol, T::Array[Symbol]), handler: String).void }
  def initialize(till:, including:, handler:)
    @till = till
    including =
      if including.is_a?(Array)
        including
      else
        [including]
      end
    @including = T.let(including, T::Array[Symbol])
    @handler = handler
  end

  sig { returns(Symbol) }
  attr_reader :till

  sig { returns(T::Array[Symbol]) }
  attr_reader :including

  sig { returns(String) }
  attr_reader :handler

  sig { returns(String) }
  def key
    "unique_job"
  end

  sig { params(arguments: T.untyped).returns(String) }
  def unique_key(arguments:)
    parts = ["unique_job", handler]
    if including.include?(INCL_ARGUMENTS)
      parts.push(JSON.dump(arguments))
    end
    parts.join("|")
  end
end
