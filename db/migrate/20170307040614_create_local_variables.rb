class CreateLocalVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :local_variables do |t|
      t.string :name
      t.boolean :forwardable, default: true
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
