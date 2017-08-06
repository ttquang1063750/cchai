class AddPerPageToOperations < ActiveRecord::Migration[5.0]
  def change
    add_column :operations, :per_page, :string
  end
end
