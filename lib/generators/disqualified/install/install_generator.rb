class Disqualified::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def copy_migration_file
    basename = "20220703062536_create_disqualified_jobs.rb"
    copy_file(basename, "db/migrate/#{basename}")

    basename = "20241119023328_create_disqualified_sequences.rb"
    copy_file(basename, "db/migrate/#{basename}")
  end
end
