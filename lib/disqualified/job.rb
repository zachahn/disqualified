# typed: strict

module Disqualified::Job
  extend T::Helpers

  module ClassMethods
    extend T::Sig

    sig { returns(Disqualified::Options) }
    private def job_options
      @job_options ||= T.let(Disqualified::Options.new, T.nilable(Disqualified::Options))
    end

    sig { params(till: Symbol, including: Symbol).void }
    private def unique(till = :until_executed, including: :arguments)
      T.bind(self, Kernel)

      if @__disqualified_unique_config
        raise Disqualified::Error::DuplicateSetting, "`unique` called more than once"
      end

      @__disqualified_unique_config = T.let(
        Disqualified::Unique.new(
          till:,
          including:,
          handler: T.unsafe(self).name
        ),
        T.nilable(Disqualified::Unique)
      )
    end

    sig { params(the_time: T.any(Time, Date, ActiveSupport::TimeWithZone), args: T.untyped).void }
    def perform_at(the_time, *args)
      metadata = {}

      if @__disqualified_unique_config
        unique_key = @__disqualified_unique_config.unique_key(arguments: args)
        random = SecureRandom.hex

        unique_record = Disqualified::Internal.create_or_find_by(unique_key:) do |record|
          record.key = @__disqualified_unique_config.key
          record.value = random
        end

        metadata[Disqualified::Unique::RECORD_METADATA_KEY] = unique_key
        metadata[Disqualified::Unique::RECORD_METADATA_VALUE] = random

        return if unique_record.value != random
      end

      Disqualified::Record.create!(
        handler: T.unsafe(self).name,
        arguments: JSON.dump(args),
        queue: "default",
        run_at: the_time,
        metadata:
      )
    end

    sig { params(args: T.untyped).void }
    def perform_async(*args)
      T.unsafe(self).perform_at(Time.now, *args)
    end

    sig { params(delay: T.any(Numeric, ActiveSupport::Duration), args: T.untyped).void }
    def perform_in(delay, *args)
      T.unsafe(self).perform_at(T.unsafe(Time.now) + delay, *args)
    end
  end

  mixes_in_class_methods(ClassMethods)
end
