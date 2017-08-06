class CreateOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :operations do |t|
      t.string :stage
      t.string :name
      t.string :operation_type
      t.text :query
      t.string :condition
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
