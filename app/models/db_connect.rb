class DbConnect < ApplicationRecord
  belongs_to :project

  %i(host database).each do |e|
    validates_presence_of e
  end
  validates :database, uniqueness: { scope: :project_id }
  scope :desc, -> { order(updated_at: :desc) }

end
