class ChangeTypeOfData < ActiveRecord::Migration[5.0]
  def change
    change_column :raws, :data, :text
  end
end
