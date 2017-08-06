class RemoveOperationTypeFromOperations < ActiveRecord::Migration[5.0]
  def change
    remove_column :operations, :operation_type, :string
  end
end
