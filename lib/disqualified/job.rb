# typed: strict

module Disqualified::Job
  extend T::Helpers

  module ClassMethods
    extend T::Sig

    sig { params(the_time: T.any(Time, Date, ActiveSupport::TimeWithZone), args: T.untyped).void }
    def perform_at(the_time, *args)
      if Thread.current[Disqualified::Sequence::UUID]
        Thread.current[Disqualified::Sequence::COUNT] += 1
        sequence_uuid = Thread.current[Disqualified::Sequence::UUID]
        sequence_step = Thread.current[Disqualified::Sequence::COUNT]
      end

      Disqualified::Record.create!(
        handler: T.unsafe(self).name,
        arguments: JSON.dump(args),
        queue: "default",
        run_at: the_time,
        sequence_uuid:,
        sequence_step:
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
