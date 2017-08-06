class Api::V1::Admin::TableSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :columns
end
