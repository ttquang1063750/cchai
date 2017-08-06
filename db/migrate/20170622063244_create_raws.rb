class CreateRaws < ActiveRecord::Migration[5.0]
  def change
    create_table :raws do |t|
      t.string     :data
      t.references :table, foreign_key: true
      t.references :row, foreign_key: true

      t.timestamps
    end
  end
end
