require "test_helper"
require "generators/disqualified/install/install_generator"

class Disqualified::InstallGeneratorTest < Rails::Generators::TestCase
  tests Disqualified::InstallGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  test "generator runs without errors" do
    assert_nothing_raised do
      run_generator
    end

    assert_operator(destination_root.join("config/initializers/disqualified.rb"), :exist?)
    assert_operator(destination_root.join("db/migrate/20220703062536_create_disqualified_jobs.rb"), :exist?)
    assert_operator(destination_root.join("db/migrate/20241119023328_create_disqualified_sequences.rb"), :exist?)
  end

  test "generator handles multiple databases" do
    assert_nothing_raised do
      run_generator(["--db", "generator_test"])
    end

    assert_operator(destination_root.join("config/initializers/disqualified.rb"), :exist?)
    assert_operator(destination_root.join("db/generator_test_migrate/20220703062536_create_disqualified_jobs.rb"), :exist?)
    assert_operator(destination_root.join("db/generator_test_migrate/20241119023328_create_disqualified_sequences.rb"), :exist?)
  end
end
