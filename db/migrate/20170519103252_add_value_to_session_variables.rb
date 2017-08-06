class AddValueToSessionVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :session_variables, :value, :string
  end
end
