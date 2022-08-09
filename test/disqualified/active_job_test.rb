require "test_helper"
require "disqualified/active_job"

class Disqualified::ActiveJobTest < ActiveSupport::TestCase
  class TestJob < ActiveJob::Base
    self.queue_adapter = :disqualified

    class << self
      attr_accessor :args
      attr_accessor :kwargs
    end

    def perform(*args, **kwargs)
      self.class.args = args
      self.class.kwargs = kwargs
    end
  end

  test "it works with positional arguments" do
    TestJob.perform_later(1, 2, 3)
    run_disqualified_jobs!
    assert_equal([1, 2, 3], TestJob.args)
    assert_equal({}, TestJob.kwargs)
  end

  test "it works with keyword arguments" do
    TestJob.perform_later(foo: :bar)
    run_disqualified_jobs!
    assert_equal([], TestJob.args)
    assert_equal({foo: :bar}, TestJob.kwargs)
  end

  test "it works when scheduled with `wait`" do
    TestJob.args = TestJob.kwargs = nil
    TestJob.set(wait: 5.minutes).perform_later(1)
    run_disqualified_jobs!
    assert_nil(TestJob.args)
    assert_nil(TestJob.kwargs)
    travel 10.minutes do
      run_disqualified_jobs!
      assert_equal([1], TestJob.args)
      assert_equal({}, TestJob.kwargs)
    end
  end

  test "it works when scheduled with `wait_until`" do
    TestJob.args = TestJob.kwargs = nil
    TestJob.set(wait_until: 5.minutes.from_now).perform_later(1)
    run_disqualified_jobs!
    assert_nil(TestJob.args)
    assert_nil(TestJob.kwargs)
    travel 10.minutes do
      run_disqualified_jobs!
      assert_equal([1], TestJob.args)
      assert_equal({}, TestJob.kwargs)
    end
  end

  private

  def run_disqualified_jobs!
    Disqualified::Main.new(logger: Logger.new(StringIO.new), error_hooks: []).call
  end
end
