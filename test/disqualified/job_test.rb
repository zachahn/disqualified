require "test_helper"

class Disqualified::JobTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  class OneArgJob
    include Disqualified::Job

    def perform(args)
    end
  end

  test ".job_options" do
    klass = Class.new do
      include Disqualified::Job
      job_options["klass"] = "klass"
    end
    llass = Class.new do
      include Disqualified::Job
      job_options["llass"] = "llass"
    end
    mlass = Class.new(llass) do
      job_options["mlass"] = "mlass"
    end

    assert_equal({"klass" => "klass"}, klass.send(:job_options).send(:to_h))
    assert_equal({"llass" => "llass"}, llass.send(:job_options).send(:to_h))
    assert_equal({"mlass" => "mlass"}, mlass.send(:job_options).send(:to_h))
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
end
