# typed: strict

class Disqualified::Cron::Registry
  extend T::Sig

  class Line
    extend T::Sig
    sig { params(schedule: String, command: String).void }
    def initialize(schedule, command)
      @schedule = T.let(schedule, String)
      @command = T.let(command, String)
    end
    sig { returns(String) }
    attr_accessor :schedule
    sig { returns(String) }
    attr_accessor :command
  end

  sig { void }
  def initialize
    @configuration_applied = T.let(false, T::Boolean)
    @registry = T.let({}, T::Hash[String, Line])
  end

  sig { params(schedule: String, command: String).void }
  def []=(schedule, command)
    s = Disqualified::Cron::Schedule.new(schedule)
    key = Digest::SHA1.hexdigest("#{s}|#{command}")
  end
end
