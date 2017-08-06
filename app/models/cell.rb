class Cell < ApplicationRecord
  belongs_to :column
  belongs_to :row

  validates_uniqueness_of :column_id, scope: :row_id

  def get_value
    case column.content_type
    when 'string'
      value
    when 'integer'
      value.to_i
    when 'float'
      value.to_f
    else
      value
    end
  end

  def self.get_cells_value(cells)
    cells.reduce({}) do |init, e|
      if e.column.content_type == 'integer'
        init.merge({"#{e.column.name}": e.value.to_i})
      else
        init.merge({"#{e.column.name}": e.value})
      end
    end
  end

end
