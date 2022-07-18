module Disqualified::Job
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def perform_at(the_time, *args)
      Disqualified::Record.create(
        handler: self.name,
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
end
