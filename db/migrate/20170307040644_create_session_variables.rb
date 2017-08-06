class CreateSessionVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :session_variables do |t|
      t.string :name
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
