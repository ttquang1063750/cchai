class Api::V1::Admin::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email

  link(:self) { api_v1_admin_user_path(object.id)}
end
