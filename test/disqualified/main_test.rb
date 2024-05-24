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
    job, _mock_worker = queue_and_mock_worker(NoArgJob)
    assert_job_ran(job)
    assert_kind_of(Time, job.finished_at)
    assert_equal(1, job.attempts)
  end

  test "it runs the job with one argument" do
    job, _mock_worker = queue_and_mock_worker(OneArgJob, "hello there")
    assert_job_ran(job)
    assert_kind_of(Time, job.finished_at)
    assert_equal(1, job.attempts)
  end

  test "it can handle failure" do
    job, mock_worker = queue_and_mock_worker(NoArgJob)
    mock_worker.expects(:perform).raises("Always Fail")
    assert_job_ran(job, success: false)
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
  end

  test "it provides a way to handle errors" do
    accepted_args = nil
    accepted_kwargs = nil
    handler = lambda do |*args, **kwargs|
      accepted_args = args
      accepted_kwargs = kwargs
    end
    job, mock_worker = queue_and_mock_worker(NoArgJob)
    mock_worker.expects(:perform).raises("Always Fail")
    assert_job_ran(job, success: false, error_hooks: [handler])
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
    assert_equal(2, accepted_args.size)
    assert_kind_of(RuntimeError, accepted_args[0])
    assert_equal("Always Fail", accepted_args[0].message)
    assert_equal([:record], accepted_args[1].keys.sort)
    assert_equal({}, accepted_kwargs)
  end

  test "it doesn't mess up when the error handling breaks" do
    handler_called = false
    handler = lambda do |*|
      handler_called = true
      raise "Handler broke"
    end
    job, mock_worker = queue_and_mock_worker(NoArgJob)
    mock_worker.expects(:perform).raises("Always Fail")
    assert_job_ran(job, success: false, error_hooks: [handler])
    assert_nil(job.finished_at)
    assert_equal(1, job.attempts)
    assert_equal(true, handler_called)
  end

  private

  def queue_and_mock_worker(klass, *arguments)
    job = Disqualified::Record.create!(
      handler: klass.name.to_s,
      arguments: arguments.to_json,
      queue: "default",
      run_at: 1.second.ago
    )
    instance = klass.new
    klass.expects(:new).returns(instance)

    [job, instance]
  end

  def assert_job_ran(job, success: true, error_hooks: [])
    original_run_at = job.run_at
    assert_difference("job.reload.attempts", 1) do
      Disqualified::Main.new(logger: Logger.new(StringIO.new), error_hooks:).call
    end
    job.reload
    assert_nil(job.locked_at)
    assert_nil(job.locked_by)
    if success
      assert_equal(original_run_at, job.run_at, "Job succeeded, but the time of next run_at changed")
    else
      assert_not_equal(original_run_at, job.run_at, "Job failed, but the time of next run_at stayed the same. Should be debounced.")
    end
  end
end
