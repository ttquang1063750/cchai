class AddItemTypeToItemMaster < ActiveRecord::Migration[5.0]
  def change
    add_column :item_masters, :item_type, :string
  end
end
