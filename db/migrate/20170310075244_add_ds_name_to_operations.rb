class AddDsNameToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :ds_name, :string
  end
end
