class RemoveForwardableFromLocalVariables < ActiveRecord::Migration[5.0]
  def change
    remove_column :local_variables, :forwardable, :boolean
  end
end
