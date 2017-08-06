class CreateRows < ActiveRecord::Migration[5.0]
  def change
    create_table :rows do |t|
      t.string :unique_id
      t.references :table, foreign_key: true

      t.timestamps
    end
  end
end
