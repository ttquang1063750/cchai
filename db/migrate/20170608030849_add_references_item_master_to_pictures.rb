class AddReferencesItemMasterToPictures < ActiveRecord::Migration[5.0]
  def change
    add_reference :pictures, :item_master, foreign_key: true
  end
end
