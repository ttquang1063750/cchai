class CsvExport < ApplicationRecord
    belongs_to :table
    belongs_to :row

    validates_presence_of :data_location

end
