class AddPaginationToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :pagination, :string
  end
end
