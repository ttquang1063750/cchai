class Api::V1::Admin::UserProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :role_types do |serializer|
    serializer.role_types_filter_by_project
  end

  def role_types_filter_by_project
    object.role_types.select { |e| e.project_id == instance_options[:project_id]}
  end
end
