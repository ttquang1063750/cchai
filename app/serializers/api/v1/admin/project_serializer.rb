class Api::V1::Admin::ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :short_name, :patitent_num, :period_start_date, :period_end_date
  belongs_to :client do
    link(:related) { api_v1_admin_client_path(id: object.client.id) }
  end

  has_many :role_types do
    link(:related) { api_v1_admin_project_role_types_path(project_id: object.id) }
  end

  has_many :pages do
    link(:related) { api_v1_admin_project_pages_path(project_id: object.id) }
  end

  has_one :db_connect do
    link(:related) { api_v1_admin_project_db_connects_path(project_id: object.id) }
  end

  link(:self) { api_v1_admin_project_path(object.id) }
end
