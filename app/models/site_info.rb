class SiteInfo < ApplicationRecord
  belongs_to :project
  has_many :sites, dependent: :destroy
  has_many :users, through: :sites
  %i(number name).each { |e| validates_presence_of e}
  %i(number name).each do |e|
    validates e, uniqueness: {scope: :project_id}
  end
  scope :filter_by_project, -> (project_id) { where(project_id: project_id) }
end
