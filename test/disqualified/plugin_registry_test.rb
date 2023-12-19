require "test_helper"

class Disqualified::PluginRegistryTest < ActiveSupport::TestCase
  class Plugin1
    include Disqualified::Plugin

    def name = "plugin1"

    def job_config_namespace = "plugin1"

    def metadata_namespace = "plugin1"
  end

  class Plugin2
    include Disqualified::Plugin

    def name = "plugin2"

    def job_config_namespace = "plugin2"

    def metadata_namespace = "plugin2"
  end

  class Plugin3
    include Disqualified::Plugin

    def name = "plugin3"

    def job_config_namespace = "plugin3"

    def metadata_namespace = "plugin3"
  end

  class Plugin4
    include Disqualified::Plugin

    def name = "plugin4"

    def job_config_namespace = "plugin4"

    def metadata_namespace = "plugin4"
  end

  test "plugins without any explcit dependencies" do
    r = Disqualified::PluginRegistry.new
    r.register(Plugin1.new)
    r.register(Plugin2.new)
    r.register(Plugin3.new)
    r.register(Plugin4.new)
    assert_equal(4, r.sorted.uniq.size)
  end

  test "plugins with explicit dependencies during registration" do
    r = Disqualified::PluginRegistry.new
    r.register(Plugin1.new, after: "plugin2")
    r.register(Plugin2.new, after: %w[plugin3 plugin4])
    r.register(Plugin3.new, before: "plugin4")
    r.register(Plugin4.new)
    assert_equal(%w[plugin3 plugin4 plugin2 plugin1], r.sorted)
  end

  test "ordering nonexistant dependencies" do
    r = Disqualified::PluginRegistry.new
    r.register(Plugin1.new, after: "plugin5")
    r.register(Plugin2.new, after: %w[plugin5 plugin1])
    assert_equal(%w[plugin1 plugin2], r.sorted)
  end
end
