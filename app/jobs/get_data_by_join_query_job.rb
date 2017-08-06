class GetDataByJoinQueryJob < ApplicationJob


  def perform join_query,id_operation
  #   data = []
  #   array_hash=[]
  #   join_query1 = join_query
  #
  #   return [] if join_query1.empty?
  #     a =join_query1.flatten.uniq
  #     a.each do |value|
  #      h={}
  #      h = Cell.where(row_id: value)
  #       array_hash << h
  #     end
  #   # Display data for API
  #   join_query1.each do |value|
  #     array_hash2 = []
  #     value.each do |value1|
  #       cells_1 = array_hash[a.index(value1)].each.reduce({}) do |init, e|
  #         init.merge({name.to_sym => e.get_value})
  #       end
  #       array_hash2 << cells_1
  #     end
  #     hash_array_hash2= {}
  #     array_hash2.each {|e| e.each{|d| hash_array_hash2.store(d[0],d[1])}}
  #     data << hash_array_hash2
  #   end
  #
  #   #Apply the condition of each columns {['by':"<", 'from': 1, 'to': 'young']}
  #   table_columns_array =[]
  #   join_query1.first.each do |row|
  #     row1 = Row.find(row)
  #       table = Table.find(row1.table_id)
  #     @table= table
  #     table_columns = table.columns
  #       table_columns_array << table_columns
  #     table_columns.each do |column|
  #       column_conditions = column.condition
  #       unless column_conditions == "" || column_conditions == nil
  #         column_name = column.name
  #         eval(column_conditions).each do |condition|
  #           array.each do |arr|
  #             if !arr[column_name.to_sym].nil? && !condition[:new_name_column].present?
  #               check_column_type_export column,params,condition,arr,column_name
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  #
  #
  #   # Create and Open the file of CSV
  #   path = File.join 'public','join',"#{@table.project_id}"
  #   FileUtils.mkdir_p(path) unless File.exist?(path)
  #   file = CSV.open(File.join(path, "#{id_operation}.csv"), "wb") do |csv|
  #     CsvJoin.create file_name: "#{id_operation}",data: File.join(path, "#{id_operation}.csv")
  #     attributes = []
  #     table_columns_array.each do |table_columns|
  #       table_columns.each do |column|
  #         column_conditions = column.condition
  #         unless column_conditions == "" || column_conditions == nil
  #          eval(column_conditions).each do |condition_name_first|
  #            if condition_name_first[:new_name_column].nil? || condition_name_first[:new_name_column] == ""
  #             attributes << column.name
  #            else
  #              attributes << condition_name_first[:new_name_column]
  #           end
  #          end
  #         else
  #           attributes << column.name
  #         end
  #       end
  #     end
  #
  #     #Fill the csv file to display it in the Csv file
  #     csv << attributes
  #     data.each do |elements|
  #       arr=[]
  #         elements.to_a.each do |element|
  #           arr<< element[1]
  #         end
  #       csv << arr
  #     end
  #   end
  #
  #   #Delete the empty row created
  #   rows = Row.where(unique_id: nil)
  #   rows.each do |row|
  #   Cell.where(row_id: row.id).each do |cell|
  #     cell.delete
  #   end
  #   row.delete
  #   end
  #   data
  # end
  #
  # def check_column_type_export column,params,condition,arr,column_name
  #   if column.content_type == "string"
  #     if condition[:by] == "=="
  #       if arr[column_name.to_sym] == condition[:form]
  #         arr[column_name.to_sym] = condition[:to]
  #       end
  #     elsif condition[:by] == "!="
  #       if arr[column_name.to_sym] != condition[:form]
  #         arr[column_name.to_sym] = condition[:to]
  #       end
  #     end
  #   elsif column.content_type == "integer"
  #     if eval([arr[column_name.to_sym],condition[:by],condition[:form]].join) == true
  #       arr[column_name.to_sym] = condition[:to]
  #     end
  #   end
  end

end