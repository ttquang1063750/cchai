class Api::V1::Admin::PageSerializer < ActiveModel::Serializer
  attributes :id, :name, :sluck, :layout

  belongs_to :project do 
    link(:related) { api_v1_admin_project_path(object.project.id) }
  end
  
  link(:self) { api_v1_admin_project_page_path(id: object.id, project_id: object.project.id) }
end
