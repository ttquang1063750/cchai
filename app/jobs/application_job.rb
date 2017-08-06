class ApplicationJob < ActiveJob::Base
  require 'csv'
  def get_cells_value(cells)
     cells.reduce({}) do |init, e| 
      if e.column.content_type == "integer"
        init.merge({"#{e.column.name}": e.value.to_i})
      else
        init.merge({"#{e.column.name}": e.value})
      end    
    end  
  end
end
