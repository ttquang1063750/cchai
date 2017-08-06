class Api::V1::Admin::PictureSerializer < ActiveModel::Serializer
  attributes :id, :image, :name
end
