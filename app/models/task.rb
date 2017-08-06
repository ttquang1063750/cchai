class Task < ApplicationRecord
  belongs_to :project

  %i(name deadline).each do |e|
    validates_presence_of e
  end
  validates :name, uniqueness: {scope: [:project_id], case_sensitive: false}
end
