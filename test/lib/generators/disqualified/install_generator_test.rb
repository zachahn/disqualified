require "test_helper"
require "generators/disqualified/install/install_generator"

class Disqualified::InstallGeneratorTest < Rails::Generators::TestCase
  tests Disqualified::InstallGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
