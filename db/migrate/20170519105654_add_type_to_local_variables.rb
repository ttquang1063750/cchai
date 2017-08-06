class AddTypeToLocalVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :local_variables, :type, :integer
  end
end
