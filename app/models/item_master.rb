class ItemMaster < ApplicationRecord
  validates :name, uniqueness: {case_sensitive: false}
  scope :desc, -> { order(created_at: :desc) }
  scoped_search on: :name

  def clone(options)
    item_master_dup = self.dup
    ItemMaster.transaction do
      item_master_dup.assign_attributes(options)
      raise ActiveRecord::Rollback unless item_master_dup.valid?
      item_master_dup.save
    end
    item_master_dup
  end
end
