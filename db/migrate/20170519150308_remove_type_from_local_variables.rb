class RemoveTypeFromLocalVariables < ActiveRecord::Migration[5.0]
  def change
    remove_column :local_variables, :type, :integer
  end
end
