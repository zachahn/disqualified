# typed: strict

class Disqualified::Pool
  extend T::Sig
  include Disqualified::Logging

  CHECK = :check
  QUIT = :quit
  RUN = :run

  sig do
    params(
      delay_range: T::Range[Float],
      logger: T.untyped,
      pool_size: Integer,
      error_hooks: T::Array[Disqualified::Logging::ERROR_HOOK_TYPE],
      task: T.proc.params(arg0: T::Hash[Symbol, T.untyped]).void
    ).void
  end
  def initialize(delay_range:, logger:, pool_size:, error_hooks:, &task)
    @delay_range = delay_range
    @logger = logger
    @pool_size = pool_size
    @error_hooks = error_hooks
    @task = task
    @running = T.let(Concurrent::AtomicBoolean.new(true), Concurrent::AtomicBoolean)
    @command_queue = T.let(Thread::Queue.new, Thread::Queue)
  end

  sig { void }
  def run!
    clock.execute
    T.unsafe(Concurrent::Promises)
      .zip(*pool)
      .rescue { |error| handle_error(@error_hooks, error, {}) }
      .run
      .value!
  end

  sig { void }
  def shutdown
    @running.make_false
    clock.shutdown
    @pool_size.times do
      @command_queue.push(Disqualified::Pool::QUIT)
    end
  end

  sig { returns(Concurrent::TimerTask) }
  def clock
    @clock ||= T.let(
      Concurrent::TimerTask.new(run_now: true) do |clock_task|
        @logger.debug { format_log("Disqualified::Pool#clock", "Starting") }
        clock_task.execution_interval = random_interval
        @command_queue.push(Disqualified::Pool::CHECK)
        @logger.debug { format_log("Disqualified::Pool#clock", "Next run in #{clock_task.execution_interval}") }
      rescue => e
        handle_error(@error_hooks, e, {})
      end,
      T.nilable(Concurrent::TimerTask)
    )
  end

  sig { returns(T::Array[T.nilable(Concurrent::Promises::Future)]) }
  def pool
    @pool ||= T.let(
      @pool_size.times.map do |promise_index|
        repeat(promise_index:)
          &.run
      end,
      T.nilable(T::Array[T.nilable(Concurrent::Promises::Future)])
    )
  end

  sig { params(promise_index: Integer).returns(T.nilable(Concurrent::Promises::Future)) }
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

  sig { returns(Float) }
  def random_interval
    rand(@delay_range)
  end
end
