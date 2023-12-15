require "test_helper"

class Disqualified::RecordTest < ActiveSupport::TestCase
  class NoArgJob
    include Disqualified::Job

    def perform
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
    claimed_record = Disqualified::Record.claim_one!
    claimed_record.unqueue
    Disqualified::Record.claim_one!
  end
end
