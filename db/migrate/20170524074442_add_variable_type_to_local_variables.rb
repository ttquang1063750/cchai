class AddVariableTypeToLocalVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :local_variables, :variable_type, :integer
  end
end
