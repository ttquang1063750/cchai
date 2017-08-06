class AddModeToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :mode, :string
  end
end
