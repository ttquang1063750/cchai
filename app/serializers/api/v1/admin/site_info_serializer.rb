class Api::V1::Admin::SiteInfoSerializer < ActiveModel::Serializer
  attributes :id, :number, :name, :remarks, :address, :tel, :fax

  belongs_to :project do
    link(:related) { api_v1_admin_project_path(object.project.id) }
  end

  link(:self) { api_v1_admin_project_site_info_path(project_id: object.project_id, id: object.id)}
end
