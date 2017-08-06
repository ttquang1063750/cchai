class AddVariableTypeToSessionVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :session_variables, :variable_type, :integer
  end
end
