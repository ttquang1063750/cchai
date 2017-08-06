class RemoveIsArrayFromOperations < ActiveRecord::Migration[5.0]
  def change
    remove_column :operations, :is_array, :boolean
  end
end
