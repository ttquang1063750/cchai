class CreateRoleTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :role_types do |t|
      t.references :project, foreign_key: true
      t.string :name

      t.timestamps
    end

    add_reference(:roles, :role_type, index: true)
  end
end
