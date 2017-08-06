class RemoveLocalTypeFromLocalVariables < ActiveRecord::Migration[5.0]
  def change
    remove_column :local_variables, :local_type, :integer
  end
end
