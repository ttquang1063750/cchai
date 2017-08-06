class Column < ApplicationRecord
  enum content_type: %i(string integer float date)
  belongs_to :table
  has_many :cells

  %i(name table).each do |e|
    validates_presence_of e
  end
  validates :name, uniqueness: {scope: :table_id}
end
