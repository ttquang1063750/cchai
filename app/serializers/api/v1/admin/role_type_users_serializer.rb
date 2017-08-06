class Api::V1::Admin::RoleTypeUsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :roles do |serializer|
    serializer.role_filter_by_role_type
  end

  has_many :role_types do |serializer|
    serializer.role_types_filter_by_project
  end

  def role_types_filter_by_project
    object.role_types.select { |e| e.project_id == instance_options[:project_id]}
  end

  def role_filter_by_role_type
    object.roles.select { |e| e.role_type_id == instance_options[:role_type_id]}
  end
end
