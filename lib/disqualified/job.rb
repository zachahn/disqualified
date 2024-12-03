module Disqualified::Job
  module ClassMethods
    def perform_at(the_time, *args)
      if Thread.current[Disqualified::Sequence::UUID]
        Thread.current[Disqualified::Sequence::COUNT] += 1
        sequence_uuid = Thread.current[Disqualified::Sequence::UUID]
        sequence_step = Thread.current[Disqualified::Sequence::COUNT]
      end

      Disqualified::Record.create!(
        handler: name,
        arguments: JSON.dump(args),
        queue: "default",
        run_at: the_time,
        sequence_uuid:,
        sequence_step:
      )
    end

    def perform_async(*args)
      perform_at(Time.now, *args)
    end

    def perform_in(delay, *args)
      perform_at(Time.now + delay, *args)
    end
  end

  def self.included(other)
    other.extend(ClassMethods)
  end
end
