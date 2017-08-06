class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :rememberable,
         :trackable, :validatable
  # :confirmable, :omniauthable, :registerable,:recoverable
  include DeviseTokenAuth::Concerns::User
  has_many :roles, dependent: :destroy
  has_many :role_types, through: :roles
  has_many :sites, dependent: :destroy
  has_many :site_infos, through: :sites
  has_many :project, -> { distinct }, through: :role_types
  validates_presence_of :name

  scope :desc, -> { order(updated_at: :desc) }

  scoped_search on: %i(email name)

  def user_role_types_by_project(project_id)
    role_types.where(project_id: project_id).pluck(:id).map(&:to_s)
  end
end
