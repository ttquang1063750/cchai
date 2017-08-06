class AddUniqueRoleNameToRoles < ActiveRecord::Migration[5.0]
  def change
    add_index :roles, [:user_id, :project_id, :name], unique: true
  end
end
