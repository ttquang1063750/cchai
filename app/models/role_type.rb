class RoleType < ApplicationRecord
  belongs_to :project
  has_many :roles, dependent: :destroy
  has_many :users, through: :roles
  validates_presence_of :name
  validates :name, uniqueness: {scope: :project_id}

  scope :filter_by_project, -> (project_id) { where(project_id: project_id) }

  DEFAULT_ROLE_TYPES = [
      'Dr', 'sub Dr', 'CRC', 'CRA', 'MR', 'QC', 'AUDIT', 'DM', 'Admin',
      'Commitee', 'CRO', 'SMO', 'GVP', 'Maker', 'Accounting'
  ]
end
