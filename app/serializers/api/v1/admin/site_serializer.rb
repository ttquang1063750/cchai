class Api::V1::Admin::SiteSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :site_info_id

  belongs_to :user do
    link(:related) { api_v1_admin_user_path(object.user.id) }
  end

  belongs_to :site_info do
    link(:related) { api_v1_admin_project_site_info_path(project_id: object.site_info.project.id, id: object.site_info.id ) }
  end

  # link(:self) { api_v1_admin_project_site_path(id: object.id, project_id: object.project.id) }
end
