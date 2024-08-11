# typed: false

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `logger` gem.
# Please instead update this file by running `bin/tapioca gem logger`.


class Logger
  include ::Logger::Severity

  # source://logger//logger.rb#578
  def initialize(logdev, shift_age = T.unsafe(nil), shift_size = T.unsafe(nil), level: T.unsafe(nil), progname: T.unsafe(nil), formatter: T.unsafe(nil), datetime_format: T.unsafe(nil), binmode: T.unsafe(nil), shift_period_suffix: T.unsafe(nil)); end

  # source://logger//logger.rb#684
  def <<(msg); end

  # source://logger//logger.rb#651
  def add(severity, message = T.unsafe(nil), progname = T.unsafe(nil)); end

  # source://logger//logger.rb#731
  def close; end

  # source://logger//logger.rb#438
  def datetime_format; end

  # source://logger//logger.rb#432
  def datetime_format=(datetime_format); end

  # source://logger//logger.rb#690
  def debug(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#487
  def debug!; end

  # source://logger//logger.rb#482
  def debug?; end

  # source://logger//logger.rb#708
  def error(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#520
  def error!; end

  # source://logger//logger.rb#515
  def error?; end

  # source://logger//logger.rb#714
  def fatal(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#531
  def fatal!; end

  # source://logger//logger.rb#526
  def fatal?; end

  # source://logger//logger.rb#473
  def formatter; end

  # source://logger//logger.rb#473
  def formatter=(_arg0); end

  # source://logger//logger.rb#696
  def info(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#498
  def info!; end

  # source://logger//logger.rb#493
  def info?; end

  # source://logger//logger.rb#383
  def level; end

  # source://logger//logger.rb#399
  def level=(severity); end

  # source://logger//logger.rb#651
  def log(severity, message = T.unsafe(nil), progname = T.unsafe(nil)); end

  # source://logger//logger.rb#422
  def progname; end

  # source://logger//logger.rb#422
  def progname=(_arg0); end

  # source://logger//logger.rb#619
  def reopen(logdev = T.unsafe(nil)); end

  # source://logger//logger.rb#383
  def sev_threshold; end

  # source://logger//logger.rb#399
  def sev_threshold=(severity); end

  # source://logger//logger.rb#720
  def unknown(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#702
  def warn(progname = T.unsafe(nil), &block); end

  # source://logger//logger.rb#509
  def warn!; end

  # source://logger//logger.rb#504
  def warn?; end

  # source://logger//logger.rb#408
  def with_level(severity); end

  private

  # source://logger//logger.rb#744
  def format_message(severity, datetime, progname, msg); end

  # source://logger//logger.rb#740
  def format_severity(severity); end
end

class Logger::Formatter
  # source://logger//logger/formatter.rb#11
  def initialize; end

  # source://logger//logger/formatter.rb#15
  def call(severity, time, progname, msg); end

  # source://logger//logger/formatter.rb#9
  def datetime_format; end

  # source://logger//logger/formatter.rb#9
  def datetime_format=(_arg0); end

  private

  # source://logger//logger/formatter.rb#21
  def format_datetime(time); end

  # source://logger//logger/formatter.rb#25
  def msg2str(msg); end
end

# source://logger//logger/formatter.rb#7
Logger::Formatter::DatetimeFormat = T.let(T.unsafe(nil), String)

# source://logger//logger/formatter.rb#6
Logger::Formatter::Format = T.let(T.unsafe(nil), String)

class Logger::LogDevice
  include ::Logger::Period
  include ::MonitorMixin

  # source://logger//logger/log_device.rb#14
  def initialize(log = T.unsafe(nil), shift_age: T.unsafe(nil), shift_size: T.unsafe(nil), shift_period_suffix: T.unsafe(nil), binmode: T.unsafe(nil)); end

  # source://logger//logger/log_device.rb#52
  def close; end

  # source://logger//logger/log_device.rb#10
  def dev; end

  # source://logger//logger/log_device.rb#11
  def filename; end

  # source://logger//logger/log_device.rb#62
  def reopen(log = T.unsafe(nil)); end

  # source://logger//logger/log_device.rb#31
  def write(message); end

  private

  # source://logger//logger/log_device.rb#119
  def add_log_header(file); end

  # source://logger//logger/log_device.rb#125
  def check_shift_log; end

  # source://logger//logger/log_device.rb#103
  def create_logfile(filename); end

  # source://logger//logger/log_device.rb#145
  def lock_shift_log; end

  # source://logger//logger/log_device.rb#95
  def open_logfile(filename); end

  # source://logger//logger/log_device.rb#79
  def set_dev(log); end

  # source://logger//logger/log_device.rb#176
  def shift_log_age; end

  # source://logger//logger/log_device.rb#188
  def shift_log_period(period_end); end
end

module Logger::Period
  private

  # source://logger//logger/period.rb#9
  def next_rotate_time(now, shift_age); end

  # source://logger//logger/period.rb#31
  def previous_period_end(now, shift_age); end

  class << self
    # source://logger//logger/period.rb#9
    def next_rotate_time(now, shift_age); end

    # source://logger//logger/period.rb#31
    def previous_period_end(now, shift_age); end
  end
end

# source://logger//logger/period.rb#7
Logger::Period::SiD = T.let(T.unsafe(nil), Integer)

# source://logger//logger.rb#738
Logger::SEV_LABEL = T.let(T.unsafe(nil), Array)

module Logger::Severity
  class << self
    # source://logger//logger/severity.rb#29
    def coerce(severity); end
  end
end

# source://logger//logger/severity.rb#19
Logger::Severity::LEVELS = T.let(T.unsafe(nil), Hash)