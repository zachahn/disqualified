# typed: strict
# frozen_string_literal: true

class Disqualified::Cron::Schedule
  extend T::Sig

  sig { params(representation: String).void }
  def initialize(representation)
    representation =
      case representation
      when "@yearly", "@annually"
        "0 0 1 1 *"
      when "@monthly"
        "0 0 1 * *"
      when "@weekly"
        "0 0 * * 0"
      when "@daily"
        "0 0 * * *"
      when "@hourly"
        "0 * * * *"
      when "@reboot"
        raise Disqualified::Error::InvalidCronSchedule, "Cannot predict next reboot"
      else
        representation
      end
    @representation = T.let(representation.split(" "), T::Array[String])

    raise Disqualified::Error::InvalidCronSchedule, "Only supports 5" if @representation.size != 5

    @minute = T.let(T.must(@representation[0]), String)
    @hour = T.let(T.must(@representation[1]), String)
    @day_of_month = T.let(T.must(@representation[2]), String)
    @month = T.let(T.must(@representation[3]), String)
    @day_of_week = T.let(T.must(@representation[4]), String)

    raise Disqualified::Error::InvalidCronSchedule, "Does not support day of week" if day_of_week != "*"
  end

  sig { returns(String) }
  attr_reader :minute, :hour, :day_of_month, :month, :day_of_week

  sig { returns(String) }
  def to_s
    @representation.join(" ")
  end


  sig { returns(T::Array[Integer]) }
  def allowable_minutes = @allowable_minutes ||= T.let(allowable(minute, 0..59), T.nilable(T::Array[Integer]))

  sig { returns(T::Array[Integer]) }
  def allowable_hours = @allowable_hours ||= T.let(allowable(hour, 0..23), T.nilable(T::Array[Integer]))

  sig { returns(T::Array[Integer]) }
  def allowable_days_of_month = @allowable_days_of_month ||= T.let(allowable(day_of_month, 1..31), T.nilable(T::Array[Integer]))

  sig { returns(T::Array[Integer]) }
  def allowable_months = @allowable_months ||= T.let(allowable(month, 1..12), T.nilable(T::Array[Integer]))

  sig { params(t: Time).returns(T.nilable(Time)) }
  def next(t = Time.now)
    t = t.getutc.change(sec: 0)
    answer = t.getutc
    pp [allowable_minutes, allowable_hours, allowable_days_of_month, allowable_months]
    next_minute = allowable_minutes.find { _1 > t.min }
    nil
  end

  sig { params(schedule_part: String, allowed_range: T::Range[Integer]).returns(T::Array[Integer]) }
  def allowable(schedule_part, allowed_range)
    result = {}

    requested_ranges, _, step = schedule_part.partition("/")

    # Expand ranges to individual numbers
    requested_ranges.split(",").each do |requested_range|
      if requested_range == "*"
        allowed_range.each { result[_1] = true }
        break
      end

      start, _, finish = requested_range.partition("-")
      if start != "" && finish != ""
        start_int = Integer(start)
        finish_int = Integer(finish)
        if !allowed_range.include?(start_int)
          raise Disqualified::Error::InvalidCronSchedule, "#{start_int} is not within allowed range of #{allowed_range}"
        end
        if !allowed_range.include?(finish_int)
          raise Disqualified::Error::InvalidCronSchedule, "#{finish_int} is not within allowed range of #{allowed_range}"
        end
        (start_int..finish_int).each { result[_1] = true }
        next
      end

      solo_int = Integer(requested_range)

      if !allowed_range.include?(solo_int)
        raise Disqualified::Error::InvalidCronSchedule, "#{solo_int} is not within allowed range of #{allowed_range}"
      end

      result[solo_int] = true
    end

    # Pick numbers that match the requested steps
    step = Integer(step.presence || "1")
    result.keys.select { _1 % step == 0 }
  end
end
