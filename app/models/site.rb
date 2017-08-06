class Site < ApplicationRecord
  belongs_to :user
  belongs_to :site_info
  delegate :project, :to => :site_info, :allow_nil => true
  validates :user_id, uniqueness: {scope: :site_info_id}
end
