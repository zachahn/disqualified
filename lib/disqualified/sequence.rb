# typed: strict

class Disqualified::Sequence
  extend T::Sig

  UUID = :disqualified_sequence_uuid
  COUNT = :disqualified_sequence_count

  sig { params(description: T.nilable(String), block: T.proc.void).void }
  def self.queue(description: nil, &block)
    Disqualified::SequenceRecord.transaction do
      Thread.current[UUID] = SecureRandom.uuid
      Thread.current[COUNT] = 0
      yield
      Disqualified::SequenceRecord.create!(
        uuid: Thread.current[UUID],
        current_step: 1,
        final_step: Thread.current[COUNT],
        description:
      )
    end
  ensure
    Thread.current[UUID] = nil
    Thread.current[COUNT] = nil
  end
end
