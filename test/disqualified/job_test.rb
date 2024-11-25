require "test_helper"

class Disqualified::JobTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  class OneArgJob
    include Disqualified::Job

    def perform
    end
  end

  class AccessCurrentJobJob
    include Disqualified::Job

    def perform
      if current_job.nil?
        raise "current job was nil"
      end

      if current_job.class != Disqualified::Record
        raise "current job was not a disqualified record"
      end

      if current_job.id != Disqualified::Record.first.id
        raise "current job id is not the current job?"
      end

      raise "the job successfully failed!"
    end
  end

  test ".perform_async" do
    freeze_time do
      assert_difference("Disqualified::Record.count", 1) do
        OneArgJob.perform_async("hello there")
      end
      Disqualified::Record.find_by!(
        handler: "Disqualified::JobTest::OneArgJob",
        arguments: ["hello there"].to_json,
        queue: "default",
        run_at: Time.now
      )
    end
  end

  test ".perform_in" do
    freeze_time do
      assert_difference("Disqualified::Record.count", 1) do
        OneArgJob.perform_in(5.minutes, "hello there")
      end
      Disqualified::Record.find_by!(
        handler: "Disqualified::JobTest::OneArgJob",
        arguments: ["hello there"].to_json,
        queue: "default",
        run_at: Time.now + (5 * 60)
      )
    end
  end

  test ".perform_at" do
    assert_difference("Disqualified::Record.count", 1) do
      OneArgJob.perform_at(Time.utc(1970, 1, 1), "hello there")
    end
    Disqualified::Record.find_by!(
      handler: "Disqualified::JobTest::OneArgJob",
      arguments: ["hello there"].to_json,
      queue: "default",
      run_at: Time.at(0)
    )
  end

  test "#current_job is probably the current job" do
    assert_equal(0, Disqualified::Record.count)
    assert_raise("the job successfully failed!") do
      AccessCurrentJobJob.perform_async
      Disqualified::Record.first.run!
    end
  end
end
