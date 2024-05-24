# typed: strict

class Disqualified::Unique
  extend T::Sig

  RECORD_METADATA_KEY = "UNIQUE_JOB_KEY"
  RECORD_METADATA_VALUE = "UNIQUE_JOB_VALUE"

  INCL_ARGUMENTS = :arguments

  sig { params(till: Symbol, including: T.any(Symbol, T::Array[Symbol]), handler: String).void }
  def initialize(till, including, handler)
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

  class Plugin
    extend T::Sig
    include Disqualified::Plugin

    sig { override.returns(String) }
    def name = "Disqualified::Plugin::Name"

    sig { override.returns(String) }
    def job_config_namespace = ""

    sig { override.returns(String) }
    def metadata_namespace = ""

    sig do
      override
        .params(
          metadata: T.untyped,
          job_options: Disqualified::Options,
          arguments: T::Array[T.untyped]
        )
        .void
    end
    def before_queue(metadata:, job_options:, arguments:)
      return if !job_options.key?("unique")

      args_for_unique = T.let(job_options["unique"], T.untyped).values_at("till", "including", "handler")
      unique = Disqualified::Unique.new(*args_for_unique)
      unique_key = unique.unique_key(arguments:)
      random = SecureRandom.hex
      unique_record = Disqualified::Internal.create_or_find_by(unique_key:) do |record|
        record.key = unique.key
        record.value = random
      end

      metadata[Disqualified::Unique::RECORD_METADATA_KEY] = unique_key
      metadata[Disqualified::Unique::RECORD_METADATA_VALUE] = random

      throw :abort if unique_record.value != random
    end

    sig { override.params(record: Disqualified::Record).void }
    def before_finish(record:)
      return unless record.metadata&.key?(Disqualified::Unique::RECORD_METADATA_KEY)

      unique_key = record.metadata.fetch(Disqualified::Unique::RECORD_METADATA_KEY)
      value = record.metadata.fetch(Disqualified::Unique::RECORD_METADATA_VALUE)
      Disqualified::Internal.where(unique_key:, value:).delete_all
    end
  end
end
