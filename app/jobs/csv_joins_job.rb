class CsvJoinsJob < ApplicationJob

  def perform
    Operation.all.each do |join|
      if join.background_mode == 1
        join.get_data_by_join_query
      end
    end
  end
end
