# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `minitest` gem.
# Please instead update this file by running `bin/tapioca gem minitest`.

# source://minitest//lib/minitest/parallel.rb#1
module Minitest
  class << self
    # source://minitest//lib/minitest.rb#173
    def __run(reporter, options); end

    # source://minitest//lib/minitest.rb#94
    def after_run(&block); end

    # source://minitest//lib/minitest.rb#66
    def autorun; end

    # source://minitest//lib/minitest.rb#19
    def backtrace_filter; end

    # source://minitest//lib/minitest.rb#19
    def backtrace_filter=(_arg0); end

    # source://minitest//lib/minitest.rb#18
    def cattr_accessor(name); end

    # source://minitest//lib/minitest.rb#1059
    def clock_time; end

    # source://minitest//lib/minitest.rb#19
    def extensions; end

    # source://minitest//lib/minitest.rb#19
    def extensions=(_arg0); end

    # source://minitest//lib/minitest.rb#264
    def filter_backtrace(bt); end

    # source://minitest//lib/minitest.rb#19
    def info_signal; end

    # source://minitest//lib/minitest.rb#19
    def info_signal=(_arg0); end

    # source://minitest//lib/minitest.rb#98
    def init_plugins(options); end

    # source://minitest//lib/minitest.rb#105
    def load_plugins; end

    # source://minitest//lib/minitest.rb#19
    def parallel_executor; end

    # source://minitest//lib/minitest.rb#19
    def parallel_executor=(_arg0); end

    # source://minitest//lib/minitest.rb#186
    def process_args(args = T.unsafe(nil)); end

    # source://minitest//lib/minitest.rb#19
    def reporter; end

    # source://minitest//lib/minitest.rb#19
    def reporter=(_arg0); end

    # source://minitest//lib/minitest.rb#140
    def run(args = T.unsafe(nil)); end

    # source://minitest//lib/minitest.rb#1050
    def run_one_method(klass, method_name); end

    # source://minitest//lib/minitest.rb#19
    def seed; end

    # source://minitest//lib/minitest.rb#19
    def seed=(_arg0); end
  end
end

# source://minitest//lib/minitest.rb#578
class Minitest::AbstractReporter
  include ::Mutex_m

  # source://mutex_m/0.1.2/mutex_m.rb#93
  def lock; end

  # source://mutex_m/0.1.2/mutex_m.rb#83
  def locked?; end

  # source://minitest//lib/minitest.rb#612
  def passed?; end

  # source://minitest//lib/minitest.rb#591
  def prerecord(klass, name); end

  # source://minitest//lib/minitest.rb#600
  def record(result); end

  # source://minitest//lib/minitest.rb#606
  def report; end

  # source://minitest//lib/minitest.rb#584
  def start; end

  # source://mutex_m/0.1.2/mutex_m.rb#78
  def synchronize(&block); end

  # source://mutex_m/0.1.2/mutex_m.rb#88
  def try_lock; end

  # source://mutex_m/0.1.2/mutex_m.rb#98
  def unlock; end
end

# source://minitest//lib/minitest.rb#895
class Minitest::Assertion < ::Exception
  # source://minitest//lib/minitest.rb#896
  def error; end

  # source://minitest//lib/minitest.rb#903
  def location; end

  # source://minitest//lib/minitest.rb#912
  def result_code; end

  # source://minitest//lib/minitest.rb#916
  def result_label; end
end

# source://minitest//lib/minitest/assertions.rb#18
module Minitest::Assertions
  # source://minitest//lib/minitest/assertions.rb#188
  def _synchronize; end

  # source://minitest//lib/minitest/assertions.rb#178
  def assert(test, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#195
  def assert_empty(obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#216
  def assert_equal(exp, act, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#240
  def assert_in_delta(exp, act, delta = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#252
  def assert_in_epsilon(exp, act, epsilon = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#259
  def assert_includes(collection, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#270
  def assert_instance_of(cls, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#281
  def assert_kind_of(cls, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#291
  def assert_match(matcher, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#303
  def assert_nil(obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#313
  def assert_operator(o1, op, o2 = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#331
  def assert_output(stdout = T.unsafe(nil), stderr = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#355
  def assert_path_exists(path, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#374
  def assert_pattern; end

  # source://minitest//lib/minitest/assertions.rb#395
  def assert_predicate(o1, op, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#422
  def assert_raises(*exp); end

  # source://minitest//lib/minitest/assertions.rb#453
  def assert_respond_to(obj, meth, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#463
  def assert_same(exp, act, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#476
  def assert_send(send_ary, m = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#492
  def assert_silent; end

  # source://minitest//lib/minitest/assertions.rb#501
  def assert_throws(sym, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#542
  def capture_io; end

  # source://minitest//lib/minitest/assertions.rb#575
  def capture_subprocess_io; end

  # source://minitest//lib/minitest/assertions.rb#59
  def diff(exp, act); end

  # source://minitest//lib/minitest/assertions.rb#607
  def exception_details(e, msg); end

  # source://minitest//lib/minitest/assertions.rb#623
  def fail_after(y, m, d, msg); end

  # source://minitest//lib/minitest/assertions.rb#630
  def flunk(msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#638
  def message(msg = T.unsafe(nil), ending = T.unsafe(nil), &default); end

  # source://minitest//lib/minitest/assertions.rb#129
  def mu_pp(obj); end

  # source://minitest//lib/minitest/assertions.rb#152
  def mu_pp_for_diff(obj); end

  # source://minitest//lib/minitest/assertions.rb#649
  def pass(_msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#656
  def refute(test, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#664
  def refute_empty(obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#675
  def refute_equal(exp, act, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#687
  def refute_in_delta(exp, act, delta = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#699
  def refute_in_epsilon(a, b, epsilon = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#706
  def refute_includes(collection, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#717
  def refute_instance_of(cls, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#727
  def refute_kind_of(cls, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#735
  def refute_match(matcher, obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#745
  def refute_nil(obj, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#780
  def refute_operator(o1, op, o2 = T.unsafe(nil), msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#789
  def refute_path_exists(path, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#762
  def refute_pattern; end

  # source://minitest//lib/minitest/assertions.rb#803
  def refute_predicate(o1, op, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#811
  def refute_respond_to(obj, meth, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#820
  def refute_same(exp, act, msg = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#833
  def skip(msg = T.unsafe(nil), bt = T.unsafe(nil)); end

  # source://minitest//lib/minitest/assertions.rb#845
  def skip_until(y, m, d, msg); end

  # source://minitest//lib/minitest/assertions.rb#854
  def skipped?; end

  # source://minitest//lib/minitest/assertions.rb#104
  def things_to_diff(exp, act); end

  class << self
    # source://minitest//lib/minitest/assertions.rb#29
    def diff; end

    # source://minitest//lib/minitest/assertions.rb#47
    def diff=(o); end
  end
end

# source://minitest//lib/minitest/assertions.rb#201
Minitest::Assertions::E = T.let(T.unsafe(nil), String)

# source://minitest//lib/minitest/assertions.rb#19
Minitest::Assertions::UNDEFINED = T.let(T.unsafe(nil), Object)

# source://minitest//lib/minitest.rb#1027
class Minitest::BacktraceFilter
  # source://minitest//lib/minitest.rb#1035
  def filter(bt); end
end

# source://minitest//lib/minitest.rb#1029
Minitest::BacktraceFilter::MT_RE = T.let(T.unsafe(nil), Regexp)

# source://minitest//lib/minitest.rb#844
class Minitest::CompositeReporter < ::Minitest::AbstractReporter
  # source://minitest//lib/minitest.rb#850
  def initialize(*reporters); end

  # source://minitest//lib/minitest.rb#862
  def <<(reporter); end

  # source://minitest//lib/minitest.rb#855
  def io; end

  # source://minitest//lib/minitest.rb#866
  def passed?; end

  # source://minitest//lib/minitest.rb#874
  def prerecord(klass, name); end

  # source://minitest//lib/minitest.rb#881
  def record(result); end

  # source://minitest//lib/minitest.rb#887
  def report; end

  # source://minitest//lib/minitest.rb#848
  def reporters; end

  # source://minitest//lib/minitest.rb#848
  def reporters=(_arg0); end

  # source://minitest//lib/minitest.rb#870
  def start; end
end

# source://minitest//lib/minitest.rb#971
module Minitest::Guard
  # source://minitest//lib/minitest.rb#976
  def jruby?(platform = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#983
  def maglev?(platform = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#993
  def mri?(platform = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#1000
  def osx?(platform = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#1007
  def rubinius?(platform = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#1017
  def windows?(platform = T.unsafe(nil)); end
end

# source://minitest//lib/minitest/parallel.rb#2
module Minitest::Parallel; end

# source://minitest//lib/minitest/parallel.rb#7
class Minitest::Parallel::Executor
  # source://minitest//lib/minitest/parallel.rb#17
  def initialize(size); end

  # source://minitest//lib/minitest/parallel.rb#43
  def <<(work); end

  # source://minitest//lib/minitest/parallel.rb#50
  def shutdown; end

  # source://minitest//lib/minitest/parallel.rb#12
  def size; end

  # source://minitest//lib/minitest/parallel.rb#26
  def start; end
end

# source://minitest//lib/minitest/parallel.rb#56
module Minitest::Parallel::Test
  # source://minitest//lib/minitest/parallel.rb#57
  def _synchronize; end
end

# source://minitest//lib/minitest/parallel.rb#59
module Minitest::Parallel::Test::ClassMethods
  # source://minitest//lib/minitest/parallel.rb#60
  def run_one_method(klass, method_name, reporter); end

  # source://minitest//lib/minitest/parallel.rb#64
  def test_order; end
end

# source://minitest//lib/minitest.rb#643
class Minitest::ProgressReporter < ::Minitest::Reporter
  # source://minitest//lib/minitest.rb#644
  def prerecord(klass, name); end

  # source://minitest//lib/minitest.rb#651
  def record(result); end
end

# source://minitest//lib/minitest.rb#475
module Minitest::Reportable
  # source://minitest//lib/minitest.rb#495
  def class_name; end

  # source://minitest//lib/minitest.rb#516
  def error?; end

  # source://minitest//lib/minitest.rb#490
  def location; end

  # source://minitest//lib/minitest.rb#482
  def passed?; end

  # source://minitest//lib/minitest.rb#502
  def result_code; end

  # source://minitest//lib/minitest.rb#509
  def skipped?; end
end

# source://minitest//lib/minitest.rb#619
class Minitest::Reporter < ::Minitest::AbstractReporter
  # source://minitest//lib/minitest.rb#628
  def initialize(io = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#621
  def io; end

  # source://minitest//lib/minitest.rb#621
  def io=(_arg0); end

  # source://minitest//lib/minitest.rb#626
  def options; end

  # source://minitest//lib/minitest.rb#626
  def options=(_arg0); end
end

# source://minitest//lib/minitest.rb#528
class Minitest::Result < ::Minitest::Runnable
  include ::Minitest::Reportable

  # source://minitest//lib/minitest.rb#561
  def class_name; end

  # source://minitest//lib/minitest.rb#537
  def klass; end

  # source://minitest//lib/minitest.rb#537
  def klass=(_arg0); end

  # source://minitest//lib/minitest.rb#542
  def source_location; end

  # source://minitest//lib/minitest.rb#542
  def source_location=(_arg0); end

  # source://minitest//lib/minitest.rb#565
  def to_s; end

  class << self
    # source://minitest//lib/minitest.rb#547
    def from(runnable); end
  end
end

# source://minitest//lib/minitest.rb#277
class Minitest::Runnable
  # source://minitest//lib/minitest.rb#431
  def initialize(name); end

  # source://minitest//lib/minitest.rb#281
  def assertions; end

  # source://minitest//lib/minitest.rb#281
  def assertions=(_arg0); end

  # source://minitest//lib/minitest.rb#427
  def failure; end

  # source://minitest//lib/minitest.rb#286
  def failures; end

  # source://minitest//lib/minitest.rb#286
  def failures=(_arg0); end

  # source://minitest//lib/minitest.rb#413
  def marshal_dump; end

  # source://minitest//lib/minitest.rb#423
  def marshal_load(ary); end

  # source://minitest//lib/minitest.rb#304
  def name; end

  # source://minitest//lib/minitest.rb#311
  def name=(o); end

  # source://minitest//lib/minitest.rb#450
  def passed?; end

  # source://minitest//lib/minitest.rb#459
  def result_code; end

  # source://minitest//lib/minitest.rb#440
  def run; end

  # source://minitest//lib/minitest.rb#466
  def skipped?; end

  # source://minitest//lib/minitest.rb#291
  def time; end

  # source://minitest//lib/minitest.rb#291
  def time=(_arg0); end

  # source://minitest//lib/minitest.rb#293
  def time_it; end

  class << self
    # source://minitest//lib/minitest.rb#1069
    def inherited(klass); end

    # source://minitest//lib/minitest.rb#318
    def methods_matching(re); end

    # source://minitest//lib/minitest.rb#383
    def on_signal(name, action); end

    # source://minitest//lib/minitest.rb#322
    def reset; end

    # source://minitest//lib/minitest.rb#333
    def run(reporter, options = T.unsafe(nil)); end

    # source://minitest//lib/minitest.rb#363
    def run_one_method(klass, method_name, reporter); end

    # source://minitest//lib/minitest.rb#400
    def runnable_methods; end

    # source://minitest//lib/minitest.rb#407
    def runnables; end

    # source://minitest//lib/minitest.rb#368
    def with_info_handler(reporter, &block); end
  end
end

# source://minitest//lib/minitest.rb#381
Minitest::Runnable::SIGNALS = T.let(T.unsafe(nil), Hash)

# source://minitest//lib/minitest.rb#924
class Minitest::Skip < ::Minitest::Assertion
  # source://minitest//lib/minitest.rb#925
  def result_label; end
end

# source://minitest//lib/minitest.rb#679
class Minitest::StatisticsReporter < ::Minitest::Reporter
  # source://minitest//lib/minitest.rb#723
  def initialize(io = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://minitest//lib/minitest.rb#683
  def assertions; end

  # source://minitest//lib/minitest.rb#683
  def assertions=(_arg0); end

  # source://minitest//lib/minitest.rb#688
  def count; end

  # source://minitest//lib/minitest.rb#688
  def count=(_arg0); end

  # source://minitest//lib/minitest.rb#716
  def errors; end

  # source://minitest//lib/minitest.rb#716
  def errors=(_arg0); end

  # source://minitest//lib/minitest.rb#711
  def failures; end

  # source://minitest//lib/minitest.rb#711
  def failures=(_arg0); end

  # source://minitest//lib/minitest.rb#736
  def passed?; end

  # source://minitest//lib/minitest.rb#744
  def record(result); end

  # source://minitest//lib/minitest.rb#754
  def report; end

  # source://minitest//lib/minitest.rb#693
  def results; end

  # source://minitest//lib/minitest.rb#693
  def results=(_arg0); end

  # source://minitest//lib/minitest.rb#721
  def skips; end

  # source://minitest//lib/minitest.rb#721
  def skips=(_arg0); end

  # source://minitest//lib/minitest.rb#740
  def start; end

  # source://minitest//lib/minitest.rb#700
  def start_time; end

  # source://minitest//lib/minitest.rb#700
  def start_time=(_arg0); end

  # source://minitest//lib/minitest.rb#706
  def total_time; end

  # source://minitest//lib/minitest.rb#706
  def total_time=(_arg0); end
end

# source://minitest//lib/minitest.rb#774
class Minitest::SummaryReporter < ::Minitest::StatisticsReporter
  # source://minitest//lib/minitest.rb#809
  def aggregated_results(io); end

  # source://minitest//lib/minitest.rb#777
  def old_sync; end

  # source://minitest//lib/minitest.rb#777
  def old_sync=(_arg0); end

  # source://minitest//lib/minitest.rb#792
  def report; end

  # source://minitest//lib/minitest.rb#780
  def start; end

  # source://minitest//lib/minitest.rb#804
  def statistics; end

  # source://minitest//lib/minitest.rb#829
  def summary; end

  # source://minitest//lib/minitest.rb#776
  def sync; end

  # source://minitest//lib/minitest.rb#776
  def sync=(_arg0); end

  # source://minitest//lib/minitest.rb#825
  def to_s; end
end

# source://minitest//lib/minitest/test.rb#10
class Minitest::Test < ::Minitest::Runnable
  include ::Minitest::Assertions
  include ::Minitest::Reportable
  include ::Minitest::Test::LifecycleHooks
  include ::Minitest::Guard
  extend ::Minitest::Guard

  # source://minitest//lib/minitest/test.rb#198
  def capture_exceptions; end

  # source://minitest//lib/minitest/test.rb#15
  def class_name; end

  # source://minitest//lib/minitest/test.rb#215
  def neuter_exception(e); end

  # source://minitest//lib/minitest/test.rb#226
  def new_exception(klass, msg, bt, kill = T.unsafe(nil)); end

  # source://minitest//lib/minitest/test.rb#94
  def run; end

  # source://minitest//lib/minitest/test.rb#208
  def sanitize_exception(e); end

  # source://minitest//lib/minitest/test.rb#240
  def with_info_handler(&block); end

  class << self
    # source://minitest//lib/minitest/test.rb#35
    def i_suck_and_my_tests_are_order_dependent!; end

    # source://minitest//lib/minitest/test.rb#26
    def io_lock; end

    # source://minitest//lib/minitest/test.rb#26
    def io_lock=(_arg0); end

    # source://minitest//lib/minitest/test.rb#48
    def make_my_diffs_pretty!; end

    # source://minitest//lib/minitest/test.rb#59
    def parallelize_me!; end

    # source://minitest//lib/minitest/test.rb#69
    def runnable_methods; end

    # source://minitest//lib/minitest/test.rb#87
    def test_order; end
  end
end

# source://minitest//lib/minitest/test.rb#121
module Minitest::Test::LifecycleHooks
  # source://minitest//lib/minitest/test.rb#171
  def after_setup; end

  # source://minitest//lib/minitest/test.rb#195
  def after_teardown; end

  # source://minitest//lib/minitest/test.rb#156
  def before_setup; end

  # source://minitest//lib/minitest/test.rb#180
  def before_teardown; end

  # source://minitest//lib/minitest/test.rb#162
  def setup; end

  # source://minitest//lib/minitest/test.rb#186
  def teardown; end
end

# source://minitest//lib/minitest/test.rb#19
Minitest::Test::PASSTHROUGH_EXCEPTIONS = T.let(T.unsafe(nil), Array)

# source://minitest//lib/minitest/test.rb#21
Minitest::Test::SETUP_METHODS = T.let(T.unsafe(nil), Array)

# source://minitest//lib/minitest/test.rb#23
Minitest::Test::TEARDOWN_METHODS = T.let(T.unsafe(nil), Array)

# source://minitest//lib/minitest.rb#933
class Minitest::UnexpectedError < ::Minitest::Assertion
  # source://minitest//lib/minitest.rb#937
  def initialize(error); end

  # source://minitest//lib/minitest.rb#942
  def backtrace; end

  # source://minitest//lib/minitest.rb#935
  def error; end

  # source://minitest//lib/minitest.rb#935
  def error=(_arg0); end

  # source://minitest//lib/minitest.rb#946
  def message; end

  # source://minitest//lib/minitest.rb#951
  def result_label; end
end

# source://minitest//lib/minitest/unit.rb#20
class Minitest::Unit
  class << self
    # source://minitest//lib/minitest/unit.rb#36
    def after_tests(&b); end

    # source://minitest//lib/minitest/unit.rb#30
    def autorun; end
  end
end

# source://minitest//lib/minitest/unit.rb#22
class Minitest::Unit::TestCase < ::Minitest::Test
  class << self
    # source://minitest//lib/minitest/unit.rb#23
    def inherited(klass); end
  end
end

# source://minitest//lib/minitest/unit.rb#21
Minitest::Unit::VERSION = T.let(T.unsafe(nil), String)

# source://minitest//lib/minitest.rb#12
Minitest::VERSION = T.let(T.unsafe(nil), String)
