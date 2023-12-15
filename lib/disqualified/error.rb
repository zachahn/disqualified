# typed: strict

module Disqualified
  class Error < StandardError
  end

  class JobAlreadyFinished < Error
  end

  class JobNotClaimed < Error
  end
end
