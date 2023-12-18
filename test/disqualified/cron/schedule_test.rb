require "test_helper"

class Disqualified::Cron::ScheduleTest < ActiveSupport::TestCase
  Invalid = Struct.new(:expression, :explanation)

  test "#next raises on invalid inputs" do
    test_cases = [
      Invalid.new("*", "Not enough parts"),
      Invalid.new("* *", "Not enough parts"),
      Invalid.new("* * *", "Not enough parts"),
      Invalid.new("* * * *", "Not enough parts"),
      Invalid.new("* * * * * *", "Too many parts"),
      Invalid.new("* * * * * * *", "Too many parts"),
      Invalid.new("60 * * * *", "Invalid minute"),
      Invalid.new("* 24 * * *", "Invalid hour"),
      Invalid.new("* * 0 * *", "Invalid day of month"),
      Invalid.new("* * 32 * *", "Invalid day of month"),
      Invalid.new("* * * 0 *", "Invalid month"),
      Invalid.new("* * * 13 *", "Invalid month"),
      Invalid.new("58-60 * * * *", "Invalid minute"),
      Invalid.new("* 22-25 * * *", "Invalid hour"),
      Invalid.new("* * 20-40 * *", "Invalid day of month"),
      Invalid.new("* * * 10-14 *", "Invalid month"),
      Invalid.new("* * * * 1", "Doesn't support day-of-week configuration")
    ]

    test_cases.each do |invalid|
      assert_raises(Disqualified::Error::InvalidCronSchedule, invalid.explanation) do
        schedule = Disqualified::Cron::Schedule.new(invalid.expression)
        schedule.next
      end
    end
  end

  Valid = Struct.new(:expression, :now, :expected, :explanation)

  test "#next returns the next time" do
    utc = Time.find_zone("Etc/UTC")
    nyc = Time.find_zone("America/New_York")
    now = utc.now.round
    hours_end = utc.parse("2023-01-01 00:59:59")
    hours_start = utc.parse("2023-01-01 01:00:00")
    dst_end = nyc.parse("2023-11-05 01:59:00")

    test_cases = [
      Valid.new("* * * * *", utc.parse("2023-01-01 00:01:23"), utc.parse("2024-01-01 00:02:00"), "Every minute"),
      Valid.new("@yearly",   utc.parse("2023-01-01 00:00:00"), utc.parse("2024-01-01 00:00:00"), "Every minute"),
      Valid.new("@annually", utc.parse("2023-01-01 00:00:00"), utc.parse("2024-01-01 00:00:00"), "Every minute"),
      Valid.new("1 * * * *", now, now + 1.minute, "Every first minute of the hour"),
      Valid.new("*,* * * * *", now, now + 1.minute, "Every minute"),
      Valid.new("1,* * * * *", now, now + 1.minute, "Every minute"),
      Valid.new("*,1 * * * *", now, now + 1.minute, "Every minute"),
      Valid.new("*,1-5 * * * *", hours_end, hours_start, "Every minute"),
      Valid.new("1-5,* * * * *", hours_end, hours_start, "Every minute"),
      Valid.new("10-15,16,30 * * * *", hours_end, hours_start + 10.minutes, "Minutes 11-16 and 30"),
      Valid.new("*/15 * * * *", hours_end, hours_start, "On 0, 15, 30, 45"),
      Valid.new("0-59/15 * * * *", hours_end, hours_start, "On 0, 15, 30, 45"),
      Valid.new("1-59/15 * * * *", hours_end, hours_start + 1.minute, "On 1, 16, 31, 46"),
    ]

    test_cases.each do |valid|
      schedule = Disqualified::Cron::Schedule.new(valid.expression)
      travel_to(valid.now) do
        assert_equal(valid.expected, schedule.next)
      end
    end
  end
end
