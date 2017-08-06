class LocalVariable < ApplicationRecord
  belongs_to :page

  validates :name, format: {with: SessionVariable::VALID_NAME_REGEX}, uniqueness: {scope: :page_id, case_sensitive: false}
  validates_presence_of :name

end
