class CreateCells < ActiveRecord::Migration[5.0]
  def change
    create_table :cells do |t|
      t.string :content
      t.references :column, foreign_key: true
      t.references :row, foreign_key: true

      t.timestamps
    end
  end
end
