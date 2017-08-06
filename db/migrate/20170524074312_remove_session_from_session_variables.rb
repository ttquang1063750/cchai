class RemoveSessionFromSessionVariables < ActiveRecord::Migration[5.0]
  def change
    remove_column :session_variables, :session_type, :integer
  end
end
