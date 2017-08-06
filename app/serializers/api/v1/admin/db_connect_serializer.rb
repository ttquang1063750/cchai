class Api::V1::Admin::DbConnectSerializer < ActiveModel::Serializer
  attributes :host, :adapter, :username, :password, :database, :port

  belongs_to :project do
    link(:related) { api_v1_admin_project_path(object.project.id) }
  end
  link(:self) { api_v1_admin_project_db_connects_path(id: object.id, project_id: object.project.id) }
end
