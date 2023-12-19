class AddMetadataToDisqualifiedJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :disqualified_jobs, :metadata, :text
  end
end
