class Table < ApplicationRecord
  has_many :rows, dependent: :destroy
  has_many :columns, dependent: :destroy
  has_many :raws, dependent: :destroy

  validates_presence_of :project_id
  validates_presence_of :name
  validates :name, uniqueness: { scope: :project_id }
end
