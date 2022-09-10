class CreateDisqualifiedJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :disqualified_jobs do |t|
      t.string :handler, null: false
      t.text :arguments, null: false
      t.string :queue, null: false
      t.datetime :run_at, null: false
      t.integer :attempts, null: false, default: 0
      t.datetime :locked_at
      t.string :locked_by
      t.datetime :finished_at

      t.timestamps
    end
  end
end
