require "test_helper"

class Disqualified::RecordTest < ActiveSupport::TestCase
  class NoArgJob
    include Disqualified::Job

    def perform
    end
  end

  class AlwaysFailJob
    include Disqualified::Job

    class Oops < StandardError
    end

    def perform
      raise Oops
    end
  end

  test ".claim_one! raises if no jobs are due" do
    NoArgJob.perform_in(1.minute)
    assert_raises(ActiveRecord::RecordNotFound) do
      Disqualified::Record.claim_one!
    end
  end

  test ".claim_one! returns a record if a job is due" do
    NoArgJob.perform_async
    record = Disqualified::Record.claim_one!
    assert_kind_of(Disqualified::Record, record)
  end

  test ".claim_one! doesn't claim a claimed job" do
    NoArgJob.perform_async
    claimed_record = Disqualified::Record.claim_one!
    assert_kind_of(Disqualified::Record, claimed_record)
    assert_raises(ActiveRecord::RecordNotFound) do
      Disqualified::Record.claim_one!
    end
  end

  test ".claim_one! claims requeued jobs" do
    NoArgJob.perform_async
    assert_difference("Disqualified::Record.first.attempts", 2) do
      assert_difference("Disqualified::Record.first.attempts", 1) do
        claimed_record = Disqualified::Record.claim_one!
        claimed_record.unclaim
      end
      assert_difference("Disqualified::Record.first.attempts", 1) do
        Disqualified::Record.claim_one!
      end
    end
  end

  test "#run! doesn't run ran jobs" do
    NoArgJob.perform_async
    record = Disqualified::Record.runnable.first
    record.update!(finished_at: Time.now)
    assert_raises(ActiveRecord::RecordNotFound) do
      record.run!
    end
  end

  test "#run! runs jobs" do
    NoArgJob.perform_async
    record = Disqualified::Record.runnable.first
    assert_difference("record.reload.attempts", 1) do
      assert_changes("record.reload.finished_at") do
        record.run!
      end
    end
  end

  test "#run! attempts a rerun on fail" do
    AlwaysFailJob.perform_async
    record = Disqualified::Record.runnable.first
    assert_difference("record.reload.attempts", 1) do
      assert_raises(AlwaysFailJob::Oops) do
        record.run!
      end
    end
    assert_difference("record.reload.attempts", 1) do
      assert_raises(AlwaysFailJob::Oops) do
        record.run!
      end
    end
  end

  test "#instantiate_handler_and_perform_with_args" do
    NoArgJob.perform_async
    record = Disqualified::Record.runnable.first
    record.update!(finished_at: Time.now, locked_by: SecureRandom.uuid)
    assert_raises(Disqualified::Error::JobAlreadyFinished) do
      record.send(:instantiate_handler_and_perform_with_args)
    end
    record.update!(finished_at: nil, locked_by: nil)
    assert_raises(Disqualified::Error::JobNotClaimed) do
      record.send(:instantiate_handler_and_perform_with_args)
    end
  end
end
