require "test_helper"

class Disqualified::MainTest < ActiveSupport::TestCase
  class NoArgJob
    def perform
    end
  end

  class OneArgJob
    def perform(arg)
    end
  end

  class FailingJob
    class Error < StandardError
    end

    def perform
      raise Error, "I always fail"
    end
  end

  test "it runs the job with no arguments" do
    job, mock = queue_job_now(NoArgJob)
    assert_job_ran(job) do
      mock.perform
    end
    assert_kind_of(Time, job.finished_at)
  end

  test "it runs the job with one argument" do
    job, mock = queue_job_now(OneArgJob, "hello there")
    assert_job_ran(job) do
      mock.perform("hello there")
    end
  end

  test "it can handle failure" do
    job, mock = queue_job_now(NoArgJob)
    Mocktail.stubs { mock.perform }.with { raise "Always Fail" }
    assert_job_ran(job, success: false) do
      mock.perform
    end
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
  end

  test "it provides a way to handle errors" do
    the_error = nil
    handler = lambda { |error| the_error = error }
    job, mock = queue_job_now(NoArgJob)
    Mocktail.stubs { mock.perform }.with { raise "Always Fail" }
    assert_job_ran(job, success: false, error_hooks: [handler]) do
      mock.perform
    end
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
    assert_equal("Always Fail", the_error.message)
  end

  test "it doesn't mess up when the error handling breaks" do
    called = false
    handler = lambda do |_|
      called = true
      raise "Handler broke"
    end
    job, mock = queue_job_now(NoArgJob)
    Mocktail.stubs { mock.perform }.with { raise "Always Fail" }
    assert_job_ran(job, success: false, error_hooks: [handler]) do
      mock.perform
    end
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
    assert_equal(true, called)
  end

  private

  def queue_job_now(klass, *arguments)
    job = Disqualified::Record.create!(
      handler: klass.name.to_s,
      arguments: arguments.to_json,
      queue: "default",
      run_at: 1.second.ago
    )
    mock = Mocktail.of_next(klass)

    [job, mock]
  end

  def assert_job_ran(job, success: true, error_hooks: [], &verification)
    original_run_at = job.run_at
    assert_difference("job.reload.attempts", 1) do
      Disqualified::Main.new(logger: Logger.new(StringIO.new), error_hooks:).call
    end
    Mocktail.verify(&verification)
    job.reload
    assert_nil(job.locked_at)
    assert_nil(job.locked_by)
    if success
      assert_equal(original_run_at, job.run_at, "Job succeeded, but the run_at changed")
    else
      assert_not_equal(original_run_at, job.run_at, "Job failed, but the run_at stayed the same")
    end
  end
end
