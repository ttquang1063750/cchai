class AddIsArrayToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :is_array, :boolean
  end
end
