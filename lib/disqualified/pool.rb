class Disqualified::Pool
  include Disqualified::Logging

  def initialize(delay_range:, logger:, pool_size:, &task)
    @delay_range = delay_range
    @logger = logger
    @pool_size = pool_size
    @task = task
    @running = Concurrent::AtomicBoolean.new(true)
  end

  def run!
    Concurrent::Promises
      .zip(*pool)
      .rescue { |error| handle_error(error) }
      .run
      .value!
  end

  def pool
    @pool ||=
      @pool_size.times.map do |promise_index|
        initial_delay = random_interval * promise_index / @pool_size
        Concurrent::Promises
          .schedule(initial_delay) do
            repeat(promise_index:, schedule: false, previous_delay: initial_delay)
          end
          .rescue { |error| handle_error(error) }
          .run
      end
  end

  def repeat(promise_index:, schedule:, previous_delay:)
    if @running.false?
      return
    end

    interval =
      if schedule
        random_interval
      else
        0
      end

    @logger.debug { format_log("[Disqualified::Pool#repeat(#{promise_index})] Interval #{interval}") }

    args = {
      promise_index:,
      running: @running
    }

    Concurrent::Promises
      .schedule(interval, args, &@task)
      .then { repeat(promise_index:, schedule: true, previous_delay: interval) }
      .rescue { |error| handle_error(error) }
  end

  private

  def random_interval
    rand(@delay_range)
  end

  def handle_error(error)
    pp error
    puts "Gracefully quitting..."
    @running.make_false
  end
end
