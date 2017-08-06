class AddProjectReferencesToTables < ActiveRecord::Migration[5.0]
  def change
    add_reference :tables, :project, foreign_key: true
  end
end
