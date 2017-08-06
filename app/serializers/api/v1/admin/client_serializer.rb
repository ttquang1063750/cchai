class Api::V1::Admin::ClientSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :projects

  link(:self) { api_v1_admin_client_path(object.id) }
end
