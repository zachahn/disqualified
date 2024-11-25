require "test_helper"

class Disqualified::SequenceTest < ActiveSupport::TestCase
  class Job1
    include Disqualified::Job
    def perform = current_sequence&.update!(context0: Time.now.utc.iso8601(10))
  end

  class Job2
    include Disqualified::Job
    def perform = current_sequence&.update!(context1: Time.now.utc.iso8601(10))
  end

  class Job3
    include Disqualified::Job
    def perform = current_sequence&.update!(context2: Time.now.utc.iso8601(10))
  end

  class Job4
    include Disqualified::Job
    def perform = current_sequence&.update!(context3: Time.now.utc.iso8601(10))
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

  test "Disqualified::Job#current_sequence in the sequence" do
    assert_equal(0, Disqualified::SequenceRecord.count)
    Disqualified::Sequence.queue do
      Job1.perform_async
      Job2.perform_async
      Job3.perform_async
      Job4.perform_async
    end
    4.times do
      # I hope this isn't too fast 😬
      Disqualified::Record.runnable.first.run!
    end
    sequence = Disqualified::SequenceRecord.first
    contexts = sequence.attributes.values_at("context0", "context1", "context2", "context3")
    assert_equal(contexts, contexts.uniq.sort)
  end

  test "Disqualified::Job#current_sequence outside a sequence" do
    assert_equal(0, Disqualified::SequenceRecord.count)
    Job1.perform_async
    Disqualified::Sequence.queue do
      Job2.perform_async
    end
    Job3.perform_async
    3.times { Disqualified::Record.runnable.first.run! }
    sequence = Disqualified::SequenceRecord.first
    contexts = sequence.attributes.values_at("context0", "context1", "context2", "context3")
    assert_nil(contexts.fetch(0))
    assert_not_nil(contexts.fetch(1))
    assert_nil(contexts.fetch(2))
    assert_nil(contexts.fetch(3))
  end

  # If something really weird happens and an old job reruns, it shouldn't have access to the current sequence anymore
  test "Disqualified::Job#current_sequence is only available on the current step" do
    assert_equal(0, Disqualified::Record.count)
    assert_equal(0, Disqualified::SequenceRecord.count)
    Disqualified::Sequence.queue do
      Job1.perform_async
    end

    # Run it the first time, checking that context0 correctly gets overwritten
    Disqualified::SequenceRecord.first.update!(context0: "hello")
    Disqualified::Record.first.run!
    assert_not_equal("hello", Disqualified::SequenceRecord.first.context0)
    assert_kind_of(Time, Time.iso8601(Disqualified::SequenceRecord.first.context0))

    # Make it runnable again
    Disqualified::Record.first.update!(finished_at: nil)
    Disqualified::Record.first.update!(locked_by: SecureRandom.uuid, locked_at: Time.now)
    Disqualified::Record.stubs(:claim_one!).returns(Disqualified::Record.first)

    # Run it the second time (usually impossible), check that sequence_record was inaccessible
    # since it wasn't its turn
    Disqualified::SequenceRecord.first.update!(context0: "hello")
    Disqualified::Record.first.run!
    assert_equal("hello", Disqualified::SequenceRecord.first.context0)
  end
end
