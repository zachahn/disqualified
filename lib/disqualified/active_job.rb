require "active_job"
require "disqualified"

class Disqualified::ActiveJobAdapter
  include Disqualified::Job

  def perform(serialized_job_data)
    ::ActiveJob::Base.execute(serialized_job_data)
  end
end

module ActiveJob
  module QueueAdapters
    class DisqualifiedAdapter
      def enqueue(job_data)
        Disqualified::ActiveJobAdapter.perform_async(job_data.serialize)
      end

      def enqueue_at(job_data, timestamp)
        timestamp = Time.at(timestamp)
        Disqualified::ActiveJobAdapter.perform_at(timestamp, job_data.serialize)
      end
    end
  end
end
