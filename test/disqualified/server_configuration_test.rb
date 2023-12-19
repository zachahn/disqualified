require "test_helper"

class Disqualified::ServerConfigurationTest < ActiveSupport::TestCase
  class Plugin1
    include Disqualified::Plugin

    def name = "plugin1"

    def job_config_namespace = "plugin1"

    def metadata_namespace = "plugin1"
  end

  test "plugin registry" do
    sc = Disqualified::ServerConfiguration.new
    sc.plugins.register(Plugin1.new)
    assert_includes(sc.plugins.sorted, "plugin1")
  end
end
