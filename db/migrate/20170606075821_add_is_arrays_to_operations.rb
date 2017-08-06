class AddIsArraysToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :is_array, :integer, default: 0
  end
end
