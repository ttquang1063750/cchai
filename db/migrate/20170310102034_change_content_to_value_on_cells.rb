class ChangeContentToValueOnCells < ActiveRecord::Migration[5.0]
  def change
    rename_column :cells, :content, :value
  end
end
