class RemoveTypeFromSessionVariables < ActiveRecord::Migration[5.0]
  def change
    remove_column :session_variables, :type, :integer
  end
end
