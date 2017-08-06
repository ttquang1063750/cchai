class CreateColumns < ActiveRecord::Migration[5.0]
  def change
    create_table :columns do |t|
      t.string :name
      t.string :content_type
      t.string :condition
      t.references :table, foreign_key: true

      t.timestamps
    end
  end
end
