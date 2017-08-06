class JoinQuery
  def initialize(hash)
    @hash =  hash.with_indifferent_access
  end

  def to_query
    convert_to_join_query @hash
  end

  private

  def convert_to_join_query hash
    output = []
    return "" if hash[:condition] == nil
    condition = hash[:condition].downcase
    if condition == "join"
      hash[:rules].each_with_index do |e, index|
        if index == 0
          data_row_table_1 = []
          data_row_table_2 = []
          row_table_1 = Row.joins(cells: :column).where(table_id:  hash[:rules][index][:sourceTable]).distinct
          start1 = Time.now
          row_table_1.each do |row|
            data_row_table_1 << get_cells_value(row.cells)
          end
          finish1 = Time.now
          puts finish1 - start1
          row_table_2 = Row.joins(cells: :column).where(table_id:  hash[:rules][index][:targetTable]).distinct
          row_table_2.each do |row|
            data_row_table_2 << get_cells_value(row.cells)
          end
          @start2 = Time.now

          case hash[:rules][index][:joinType]
            when "inner"
              data_row_table_1.each do |data_table_1|
                data_row_table_2.each do |data_table_2|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output << data_table_1.merge(data_table_2)
                  end
                end
              end

            when "left"
              temp = []
              not_found = Column.where(table_id:  hash[:rules][index][:targetTable]).reduce({}) do |init, e|
                init.merge({"#{e.name}": ""})
              end
              data_row_table_1.each_with_index do |data_table_1, key|
                data_row_table_2.each do |data_table_2|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output << data_table_1.merge(data_table_2)
                    temp << key
                  end
                end
              end
              if !temp.empty?
                data_row_table_1.each_with_index do |v,k|
                    if temp.uniq.include?(k) == false
                      output << v.merge(not_found)
                    end
                end
              end
            when "right"
              temp = []
              not_found = Column.where(table_id:  hash[:rules][index][:sourceTable]).reduce({}) do |init, e|
                init.merge({"#{e.name}": ""})
              end
              data_row_table_2.each_with_index do |data_table_2, key|
                data_row_table_1.each do |data_table_1|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output << data_table_2.merge(data_table_1)
                    temp << key
                  end
                end
              end
              if !temp.empty?
                data_row_table_2.each_with_index do |v,k|
                  if temp.uniq.include?(k) == false
                    output << v.merge(not_found)
                  end
                end
              end
          end
          @finish2 = Time.now
          puts @finish2 - @start2
        else

          data_row_table_1 = []
          data_row_table_2 = []
          row_table_1 = Row.joins(cells: :column).where(table_id:  hash[:rules][index][:sourceTable]).distinct
          row_table_1.each do |row|
            data_row_table_1 << get_cells_value(row.cells)
          end
          row_table_2 = Row.joins(cells: :column).where(table_id:  hash[:rules][index][:targetTable]).distinct
          row_table_2.each do |row|
            data_row_table_1 << get_cells_value(row.cells)
          end
          case hash[:rules][index][:joinType]
            when "inner"
              data_row_table_1.each do |data_table_1|
                data_row_table_2.each do |data_table_2|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output.each do |arr|
                      if arr.has_key?(hash[:rules][index][:sourceField]) && arr.has_value?(hash[:rules][index][:sourceField].to_sym)
                        arr.merge(data_table_2)
                      end
                    end
                  end
                end
              end
            when "left"
              temp = []
              not_found = Column.where(table_id:  hash[:rules][index][:targetTable]).reduce({}) do |init, e|
                init.merge({"#{e.name}": ""})
              end
              data_row_table_1.each do |data_table_1|
                data_row_table_2.each do |data_table_2|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output.each_with_index do |arr, key|
                      if arr.has_key?(hash[:rules][index][:sourceField]) && arr.has_value?(hash[:rules][index][:sourceField].to_sym)
                        arr.merge(data_table_1.merge(data_table_2))
                        temp << key
                      end
                    end
                  end
                end
              end
              if !temp.empty?
                output.each_with_index do |v,k|
                  if temp.uniq.include?(k) == false
                      v.merge(not_found)
                  end
                end
              end
            when "right"
              temp = []
              not_found = Column.where(table_id:  hash[:rules][index][:sourceTable]).reduce({}) do |init, e|
                init.merge({"#{e.name}": ""})
              end
              data_row_table_2.each do |data_table_2|
                data_row_table_1.each do |data_table_1|
                  if data_table_1[hash[:rules][index][:sourceField].to_sym] ==  data_table_2[hash[:rules][index][:targetField].to_sym]
                    output.each_with_index do |arr, key|
                      if arr.has_key?(hash[:rules][index][:sourceField]) && arr.has_value?(hash[:rules][index][:sourceField].to_sym)
                        arr.merge(data_table_2.merge(data_table_1))
                        temp << key
                      end
                    end
                  end
                end
              end
              if !temp.empty?
                output.each_with_index do |v,k|
                  if temp.uniq.include?(k) == false
                      v.merge(not_found)
                  end
                end
              end
          end

        end
      end
    end
    output
  end

  def get_cells_value cells
    cells.reduce({}) do |init, e|
      init.merge({"#{e.column.name}": e.value})
    end
  end
end

hash = {
    "condition": "JOIN",
    "rules": [
        {
            "sourceTable": 10,
            "targetTable": 10,
            "joinType": "inner",
            "sourceField": "DOCTOR1",
            "targetField": "DOCTOR1"
        },
        # {
        #     "sourceTable": 10,
        #     "targetTable": 10,
        #     "joinType": "inner",
        #     "sourceField": "DOCTOR1",
        #     "targetField": "DOCTOR1"
        # }
    # {
    #     "sourceTable": 15,
    #     "targetTable": 16,
    #     "joinType": "inner",
    #     "sourceField": "User_id",
    #     "targetField": "user_id"
    # }
    ],
    "valid": true
}
# start = Time.now
#
# @data = JoinQuery.new(hash).to_query
# puts @data
# puts @data.length
# finish = Time.now
# puts finish - start