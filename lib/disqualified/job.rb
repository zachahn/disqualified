module Disqualified::Job
  module ClassMethods
    def perform_at(the_time, *args)
      Disqualified::Record.create!(
        handler: name,
        arguments: JSON.dump(args),
        queue: "default",
        run_at: the_time
      )
    end

    def perform_async(*args)
      perform_at(Time.now, *args)
    end

    def perform_in(delay, *args)
      perform_at(Time.now + delay, *args)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end
end
