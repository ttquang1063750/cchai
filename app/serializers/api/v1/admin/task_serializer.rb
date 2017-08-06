class Api::V1::Admin::TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :deadline
  belongs_to :project do
    link(:related) { api_v1_admin_project_path(object.project.id) }
  end
end
