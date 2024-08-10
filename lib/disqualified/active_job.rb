# typed: strict

require "active_job"
require "disqualified"

class Disqualified::ActiveJobAdapter
  extend T::Sig
  include Disqualified::Job

  sig { params(serialized_job_data: T::Hash[String, T.untyped]).void }
  def perform(serialized_job_data)
    ::ActiveJob::Base.execute(serialized_job_data)
  end
end

module ActiveJob
  module QueueAdapters
    class DisqualifiedAdapter
      extend T::Sig

      sig { returns(T::Boolean) }
      def enqueue_after_transaction_commit?
        Disqualified.client_options.enqueue_after_transaction_commit
      end

      sig { params(job_data: ActiveJob::Base).void }
      def enqueue(job_data)
        Disqualified::ActiveJobAdapter.perform_async(job_data.serialize)
      end

      sig { params(job_data: ActiveJob::Base, timestamp: Numeric).void }
      def enqueue_at(job_data, timestamp)
        timestamp = Time.at(timestamp)
        Disqualified::ActiveJobAdapter.perform_at(timestamp, job_data.serialize)
      end
    end
  end
end
