# typed: strict

require "test_helper"

class Disqualified::ConfigurationTest < ActiveSupport::TestCase
  test "initializer is fine" do
    original_options = Disqualified.server_options

    Disqualified.server_options = Disqualified::ServerConfiguration.new
    load(File.expand_path("../../lib/generators/disqualified/install/templates/initializer.rb", __dir__))

    default_server_options = Disqualified::ServerConfiguration.new
    initializer_options = T.must(Disqualified.server_options)

    assert_equal(default_server_options.delay_high, initializer_options.delay_high)
    assert_equal(default_server_options.delay_low, initializer_options.delay_low)
    assert_equal(default_server_options.logger, initializer_options.logger)
    assert_equal(default_server_options.pool_size, initializer_options.pool_size)
    assert_equal(default_server_options.pwd, initializer_options.pwd)
    assert_equal(default_server_options.claim_duration, initializer_options.claim_duration)
    assert_equal(1, initializer_options.error_hooks.size)
    assert_output(/StandardError.*orange.*mocha/m) do
      T.must(initializer_options.error_hooks.first).call(StandardError.new, {orange: :mocha})
    end
  ensure
    Disqualified.server_options = original_options
  end
end
