class Api::V1::Admin::RoleTypeSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :project do
    link(:related) { api_v1_admin_project_path(object.project.id) }
  end

  link(:self) { api_v1_admin_project_role_type_path(project_id: object.project_id, id: object.id)}
end
