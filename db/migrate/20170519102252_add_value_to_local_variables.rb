class AddValueToLocalVariables < ActiveRecord::Migration[5.0]
  def change
    add_column :local_variables, :value, :text
  end
end
