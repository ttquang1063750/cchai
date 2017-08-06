class Api::V1::Admin::ItemMasterSerializer < ActiveModel::Serializer
  attributes :id, :name, :layout, :item_type, :created_at
end
