class Api::V1::Admin::ColumnSerializer < ActiveModel::Serializer
  attributes :id, :name, :content_type, :condition, :required
end
