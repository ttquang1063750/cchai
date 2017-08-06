class ChangeIsArrayFromOperations < ActiveRecord::Migration[5.0]
  def change
    change_column :operations, :is_array, :boolean, default: false
  end
end
