class RemovePaginationFromOperations < ActiveRecord::Migration[5.0]
  def change
    remove_column :operations, :pagination, :string
  end
end
