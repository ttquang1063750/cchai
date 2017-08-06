class RemoveProjectReferencesFromRoles < ActiveRecord::Migration[5.0]
  def change
    remove_reference :roles, :project, foreign_key: true
  end
end
