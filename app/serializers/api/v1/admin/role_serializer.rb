class Api::V1::Admin::RoleSerializer < ActiveModel::Serializer
  attributes :id, :name
  
  belongs_to :user do
    link(:related) { api_v1_admin_user_path(object.user.id) }
  end

  belongs_to :role_type do
    link(:related) { api_v1_admin_project_role_type_path(project_id: object.role_type.project.id, id: object.role_type.id ) }
  end

  link(:self) { api_v1_admin_project_role_path(id: object.id, project_id: object.project.id) }
end
