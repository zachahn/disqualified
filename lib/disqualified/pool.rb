class Disqualified::Pool
  include Disqualified::Logging

  CHECK = :check
  QUIT = :quit
  RUN = :run

  def initialize(delay_range:, logger:, pool_size:, error_hooks:, &task)
    @delay_range = delay_range
    @logger = logger
    @pool_size = pool_size
    @error_hooks = error_hooks
    @task = task
    @running = Concurrent::AtomicBoolean.new(true)
    @command_queue = Thread::Queue.new
  end

  def run!
    clock.execute
    Concurrent::Promises
      .zip(*pool)
      .rescue { |error| handle_error(@error_hooks, error, {}) }
      .run
      .value!
  end

  def shutdown
    @running.make_false
    clock.shutdown
    @pool_size.times do
      @command_queue.push(Disqualified::Pool::QUIT)
    end
  end

  def clock
    @clock ||= Concurrent::TimerTask.new(run_now: true) do |clock_task|
      @logger.debug { format_log("Disqualified::Pool#clock", "Starting") }
      clock_task.execution_interval = random_interval
      @command_queue.push(Disqualified::Pool::CHECK)
      @logger.debug { format_log("Disqualified::Pool#clock", "Next run in #{clock_task.execution_interval}") }
    rescue => e
      handle_error(@error_hooks, e, {})
    end
  end

  def pool
    @pool ||=
      @pool_size.times.map do |promise_index|
        repeat(promise_index:)
          .run
      end
  end

  def repeat(promise_index:)
    if @running.false?
      return
    end

    @logger.debug { format_log("Disqualified::Pool#repeat(#{promise_index})", "Started") }

    args = {promise_index:}

    Concurrent::Promises
      .future(args) do |args|
        @logger.debug { format_log("Disqualified::Pool#repeat(#{promise_index}) <pre-exec>", "Waiting for command") }
        command = @command_queue.pop
        @logger.debug { format_log("Disqualified::Pool#repeat(#{promise_index}) <pre-exec>", "Command: #{command}") }

        case command
        when Disqualified::Pool::QUIT
          nil
        when Disqualified::Pool::CHECK
          Rails.application.reloader.wrap do
            pending_job_count = Disqualified::Record
              .where(finished_at: nil, run_at: (..Time.now), locked_by: nil)
              .count

            pending_job_count.times do
              @command_queue.push(Disqualified::Pool::RUN)
            end
          end
        when Disqualified::Pool::RUN
          @task.call(args)
        end
      rescue => e
        handle_error(@error_hooks, e, {})
      end
      .then { repeat(promise_index:) }
  end

  private

  def random_interval
    rand(@delay_range)
  end
end
