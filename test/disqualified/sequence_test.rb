require "test_helper"

class Disqualified::SequenceTest < ActiveSupport::TestCase
  class Job1
    include Disqualified::Job
    def perform = nil
  end

  class Job2
    include Disqualified::Job
    def perform = nil
  end

  class Job3
    include Disqualified::Job
    def perform = nil
  end

  class Job4
    include Disqualified::Job
    def perform = nil
  end

  class Expected < StandardError
  end

  test ".queue" do
    assert_difference("Disqualified::SequenceRecord.count", 1) do
      assert_difference("Disqualified::Record.count", 3) do
        Disqualified::Sequence.queue do
          Job1.perform_async
          Job2.perform_async
          Job3.perform_async
        end
      end
    end
    uuid = Disqualified::SequenceRecord.first.uuid
    actual = ["Disqualified::SequenceTest::Job1", "Disqualified::SequenceTest::Job2", "Disqualified::SequenceTest::Job3"]
    assert_equal(actual, Disqualified::Record.where(sequence_uuid: uuid).order(sequence_step: :asc).map(&:handler))
  end

  test ".queue is transactional" do
    assert_no_difference("Disqualified::SequenceRecord.count") do
      assert_no_difference("Disqualified::Record.count") do
        assert_raises(Expected) do
          Disqualified::Sequence.queue do
            Job1.perform_async
            raise Expected
          end
        end
      end
    end
  end

  test "Disqualified::Record.runnable works" do
    Disqualified::Sequence.queue do
      Job1.perform_async
      Job2.perform_async
      Job3.perform_async
    end
    Job4.perform_async
    assert_equal(%w[Disqualified::SequenceTest::Job1 Disqualified::SequenceTest::Job4], Disqualified::Record.runnable.map(&:handler))
    Disqualified::Record.runnable.first.run!
    assert_equal(%w[Disqualified::SequenceTest::Job2 Disqualified::SequenceTest::Job4], Disqualified::Record.runnable.map(&:handler))
    Disqualified::Record.runnable.first.run!
    assert_equal(%w[Disqualified::SequenceTest::Job3 Disqualified::SequenceTest::Job4], Disqualified::Record.runnable.map(&:handler))
    Disqualified::Record.runnable.first.run!
    assert_equal(%w[Disqualified::SequenceTest::Job4], Disqualified::Record.runnable.map(&:handler))
    Disqualified::Record.runnable.first.run!
    assert_equal(%w[], Disqualified::Record.runnable.map(&:handler))
  end

  test "sequences tuples of (uuid, step) must be unique" do
    SecureRandom.expects(:uuid).returns("7a4f97be-4f70-4e43-8435-6c7a30a32164").twice
    Disqualified::Sequence.queue do
      Job1.perform_async
    end
    assert_raises(ActiveRecord::RecordNotUnique) do
      Disqualified::Sequence.queue do
        Job1.perform_async
      end
    end
  end

  test "non-sequences don't need to be unique" do
    assert_difference("Disqualified::Record.where(sequence_uuid: nil).count", 2) do
      Job2.perform_async
      Job2.perform_async
    end
  end
end
