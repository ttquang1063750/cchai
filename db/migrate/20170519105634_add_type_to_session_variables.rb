class AddTypeToSessionVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :session_variables, :type, :integer
  end
end
