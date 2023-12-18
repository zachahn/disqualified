# typed: strict

module Disqualified
  module Error
    class DisqualifiedError < StandardError
    end

    class JobAlreadyFinished < DisqualifiedError
    end

    class JobNotClaimed < DisqualifiedError
    end

    class InvalidCronSchedule < DisqualifiedError
    end
  end
end
