class Api::V1::Admin::OperationSerializer < ActiveModel::Serializer
  attributes :id, :ds_name, :name, :stage, :query, :per_page, :is_array
end
