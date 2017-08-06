class CreateDbConnects < ActiveRecord::Migration[5.0]
  def change
    create_table :db_connects do |t|
      t.string :host
      t.string :adapter
      t.string :username
      t.string :password
      t.string :database
      t.integer :port
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
