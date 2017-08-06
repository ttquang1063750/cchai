class CreateLogChangements < ActiveRecord::Migration[5.0]
  def change
    create_table :log_changements do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :page_id
      t.integer :column_id
      t.string :column_name
      t.string :bf_item
      t.string :af_item
      t.string :project_name
      t.string :page_name

      t.timestamps
    end
  end
end
