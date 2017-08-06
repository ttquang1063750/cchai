class Role < ApplicationRecord
  belongs_to :user
  belongs_to :role_type
  delegate :project, :to => :role_type, :allow_nil => true
  validates :user_id, uniqueness: {scope: :role_type_id}
end
