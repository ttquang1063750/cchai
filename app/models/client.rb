class Client < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates_presence_of :name
  validates :name, uniqueness: { case_sensitive: false }

end
