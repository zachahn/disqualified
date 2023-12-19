class CreateDisqualifiedInternals < ActiveRecord::Migration[7.0]
  def change
    create_table :disqualified_internals do |t|
      t.text :key, null: false
      t.text :unique_key
      t.text :value

      t.timestamps

      t.index :key
      t.index :unique_key, unique: true
    end
  end
end
