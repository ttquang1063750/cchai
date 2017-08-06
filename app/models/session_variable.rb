class SessionVariable < ApplicationRecord
  belongs_to :project
  VALID_NAME_REGEX = /\A[$_\p{L}][$_\p{L}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\u200C\u200D]*+\z/
  validates :name, format: {with: VALID_NAME_REGEX}, uniqueness: {scope: :project_id, case_sensitive: false}

end
