require "test_helper"

class Disqualified::ServerConfigurationTest < ActiveSupport::TestCase
  test "can configure cron" do
    sc = Disqualified::ServerConfiguration.new
    sc.cron.register do |cron|
      cron["0 0 0 0 0"] = "ClassName"
      cron["0 0 0 0 0"] = "OtherClassName"
    end
    assert_equal(2, sc.cron.registry.to_h.size)
  end
end
