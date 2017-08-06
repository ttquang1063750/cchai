class AddLocalTypeToSessionVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :session_variables, :session_type, :integer
  end
end
