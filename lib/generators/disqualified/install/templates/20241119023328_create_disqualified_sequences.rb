class CreateDisqualifiedSequences < ActiveRecord::Migration[7.2]
  def change
    create_table :disqualified_sequences do |t|
      t.text :uuid, null: false
      t.integer :current_step, null: false
      t.integer :final_step, null: false
      t.text :description
      t.timestamps
    end

    add_index :disqualified_sequences, :uuid, unique: true

    add_column :disqualified_jobs, :sequence_uuid, :text
    add_column :disqualified_jobs, :sequence_step, :integer
  end
end
