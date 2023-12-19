require "test_helper"

class Disqualified::UniqueTest < ActiveSupport::TestCase
  class UniqueJob
    include Disqualified::Job

    unique(:until_executed)

    def perform = nil
  end

  class Unique2Job
    include Disqualified::Job

    unique(:until_executed)

    def perform = nil
  end

  class UniqueArgJob
    include Disqualified::Job

    unique(:until_executed)

    def perform(arg) = nil
  end

  test "only one when scheduling" do
    now = Time.now.round

    assert_difference "Disqualified::Record.count", 1 do
      UniqueJob.perform_at(now + 10.minutes)
      UniqueJob.perform_at(now + 15.minutes)
      UniqueJob.perform_at(now + 2.minutes)
      UniqueJob.perform_in(1.minute)
      UniqueJob.perform_in(3.minutes)
      UniqueJob.perform_async
    end

    assert_equal(now + 10.minutes, Disqualified::Record.find_by!(handler: UniqueJob.name).run_at)
  end

  test "only one when immediate" do
    assert_difference "Disqualified::Record.count", 1 do
      UniqueJob.perform_async
      UniqueJob.perform_async
    end
  end

  test "queues after running" do
    UniqueJob.perform_async
    assert_difference "Disqualified::Record.count", 0 do
      UniqueJob.perform_async
    end
    Disqualified::Record.first.run!
    assert_difference "Disqualified::Record.count", 1 do
      UniqueJob.perform_async
    end
  end

  test "looks at arguments" do
    assert_difference "Disqualified::Record.count", 1 do
      UniqueArgJob.perform_async(1)
      UniqueArgJob.perform_async(1)
    end
    assert_difference "Disqualified::Record.count", 1 do
      UniqueArgJob.perform_async(2)
      UniqueArgJob.perform_async(2)
    end
  end

  test "unrelated jobs don't matter" do
    assert_difference "Disqualified::Record.count", 2 do
      UniqueJob.perform_async
      Unique2Job.perform_async
    end
  end

  test "can't call multiple times" do
    assert_raise(Disqualified::Error::DuplicateSetting) do
      Class.new.tap do |klass|
        Disqualified::UniqueTest.const_set(:TEST_A, klass)
        klass.instance_exec do
          include Disqualified::Job

          unique(:until_executed)
          unique(:until_executed)

          def perform = nil
        end
      end
    end
  end

  test "can't be called during runtime (at least not easily)" do
    klass = Class.new do
      include Disqualified::Job
    end

    assert_raise(NoMethodError) do
      klass.unique
    end
  end
end
