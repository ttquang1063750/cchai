class AddLocalTypeToLocalVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :local_variables, :local_type, :integer
  end
end
