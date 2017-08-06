class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :project, foreign_key: true
      t.date :dead_line

      t.timestamps
    end
  end
end
