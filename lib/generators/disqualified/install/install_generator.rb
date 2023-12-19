class Disqualified::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  MIGRATION_FILES = [
    "20220703062536_create_disqualified_jobs.rb",
    "20231218213817_create_disqualified_internals.rb",
    "20231218232905_add_metadata_to_disqualified_jobs.rb"
  ]

  def copy_migration_files
    MIGRATION_FILES.each do |basename|
      copy_file basename, "db/migrate/#{basename}"
    end
  end
end
