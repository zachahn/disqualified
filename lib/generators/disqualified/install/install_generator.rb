require "rails/generators/active_record"

class Disqualified::InstallGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates", __dir__)

  class_option :database,
    type: :string,
    aliases: %i[--db],
    desc: "The database for your migration. By default, the current environment's primary database is used."

  def copy_migration_file
    basename = "20220703062536_create_disqualified_jobs.rb"
    copy_file(basename, File.join(db_migrate_path, basename))

    basename = "20241119023328_create_disqualified_sequences.rb"
    copy_file(basename, File.join(db_migrate_path, basename))
  end
end
