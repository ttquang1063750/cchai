class Raw < ApplicationRecord
  belongs_to :table
  belongs_to :row

  validates_presence_of :data

end
