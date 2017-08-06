class RemoveItemMasterRefFromPictures < ActiveRecord::Migration[5.0]
  def change
    remove_reference :pictures, :item_master, foreign_key: true
  end
end
