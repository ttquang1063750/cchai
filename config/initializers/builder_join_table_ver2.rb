require 'json'
class JoinQueryVer2
  def initialize(hash, id, connect)
    @hash =  hash.with_indifferent_access
    @id_operation = id
    @connect = connect
  end

  def to_query
    convert_to_join_query(@hash, @id_operation, @connect)
  end

  private

  def convert_to_join_query(hash, id_operation, connect)
    output = []
    @operation = Operation.find_by_id(id_operation)
    @page = Page.find_by_id(@operation.page_id)
    @project = Project.find_by_id(@page.project_id)
    return "" if hash[:condition] == nil
    condition = hash[:condition].downcase
    Octopus.using(connect.database.to_sym) do
      if condition == "join"
        hash[:rules].each_with_index do |e, index|
          source_field = e[:source_field]
          target_field = e[:target_field]
          source_table = Table.find_by(name: e[:source_table], project_id: @project.id)
          target_table = Table.find_by(name: e[:target_table], project_id: @project.id)
          if index == 0
            data_row_source_table = []
            data_row_target_table = []
            if hash[:clause][:rules].nil?
              Raw.where(table_id: source_table.id).pluck(:data, :row_id).each { |data| data_row_source_table << Oj.load(data[0]).merge({"#{e[:source_table]}_row_id" => data[1]}) }
              Raw.where(table_id: target_table.id).pluck(:data, :row_id).each { |data| data_row_target_table << Oj.load(data[0]).merge({"#{e[:target_table]}_row_id" => data[1]}) }
            else
              raws_source_table = get_data_by_hash_clause hash[:clause][:condition], hash[:clause][:rules], source_table.id, connect
              raws_target_table = get_data_by_hash_clause hash[:clause][:condition], hash[:clause][:rules], target_table.id, connect
              if raws_source_table.nil?
                Raw.where(table_id: source_table.id).pluck(:data, :row_id).each { |data| data_row_source_table << Oj.load(data[0]).merge({"#{e[:source_table]}_row_id" => data[1]}) }
              else
                raws_source_table.each { |raw| data_row_source_table << Oj.load(raw.data).merge({"#{e[:source_table]}_row_id" => raw.row_id}) }
              end  
              if raws_target_table.nil?
                Raw.where(table_id: target_table.id).pluck(:data, :row_id).each { |data| data_row_target_table << Oj.load(data[0]).merge({"#{e[:target_table]}_row_id" => data[1]}) }
              else  
                raws_target_table.each { |raw| data_row_target_table << Oj.load(raw.data).merge({"#{e[:target_table]}_row_id" => raw.row_id}) }   
              end  
            end
            case e[:join_type]
              when "inner"
                data_row_source_table.each do |data_source_table|
                  row_1 = data_source_table[source_field]
                  data_row_target_table.each do |data_target_table|
                    if row_1 == data_target_table[target_field]
                      output << data_source_table.merge(data_target_table.merge({"row_id" => [data_source_table["#{e[:source_table]}_row_id"], data_target_table["#{e[:target_table]}_row_id"]]}))
                    end
                  end
                end
              when "left"
                temp = []
                not_found = Column.where(table_id: target_table.id).reduce({}) { |init, v| init.merge({"#{v.name}": ""}) }
                data_row_source_table.each_with_index do |data_source_table, key|
                  row_1 = data_source_table[source_field]
                  data_row_target_table.each do |data_target_table|
                    if row_1 ==  data_target_table[target_field]
                      output << data_source_table.merge(data_target_table.merge({"row_id" => [data_source_table["#{e[:source_table]}_row_id"], data_target_table["#{e[:target_table]}_row_id"]]}))
                      temp << key
                    end
                  end
                end
                data_row_source_table.each_with_index { |v,k| output << v.merge(not_found).merge({"row_id" =>[v["#{e[:source_table]}_row_id"]]}) if temp.uniq.include?(k) == false } unless temp.empty?
              when "right"
                temp = []
                not_found = Column.where(table_id:  source_table.id).reduce({}) { |init, v| init.merge({"#{v.name}": ""}) }
                data_row_target_table.each_with_index do |data_target_table, key|
                  row_2 = data_target_table[target_field]
                  data_row_source_table.each do |data_source_table|
                    if row_2 ==  data_source_table[source_field]
                      output << data_source_table.merge(data_target_table.merge({"row_id" => [data_source_table["#{e[:source_table]}_row_id"], data_target_table["#{e[:target_table]}_row_id"]]}))
                      temp << key
                    end
                  end
                end
                data_row_target_table.each_with_index { |v,k| output << v.merge(not_found).merge({"row_id" =>[v["#{e[:target_table]}_row_id"]]}) if temp.uniq.include?(k) == false } unless temp.empty?
            end
          else
            data_row_source_table = []
            data_row_target_table = []
            if hash[:clause][:rules].nil?
              Raw.where(table_id: source_table.id).pluck(:data, :row_id).each { |data| data_row_source_table << Oj.load(data[0]).merge({"#{e[:source_table]}_row_id" => data[1]}) }
              Raw.where(table_id: target_table.id).pluck(:data, :row_id).each { |data| data_row_target_table << Oj.load(data[0]).merge({"#{e[:target_table]}_row_id" => data[1]}) }
            else
             raws_source_table = get_data_by_hash_clause hash[:clause][:condition], hash[:clause][:rules], source_table.id, connect
              raws_target_table = get_data_by_hash_clause hash[:clause][:condition], hash[:clause][:rules], target_table.id, connect
              if raws_source_table.nil?
                Raw.where(table_id: source_table.id).pluck(:data, :row_id).each { |data| data_row_source_table << Oj.load(data[0]).merge({"#{e[:source_table]}_row_id" => data[1]}) }
              else
                raws_source_table.each { |raw| data_row_source_table << Oj.load(raw.data).merge({"#{e[:source_table]}_row_id" => raw.row_id}) }
              end  
              if raws_target_table.nil?
                Raw.where(table_id: target_table.id).pluck(:data, :row_id).each { |data| data_row_target_table << Oj.load(data[0]).merge({"#{e[:target_table]}_row_id" => data[1]}) }
              else  
                raws_target_table.each { |raw| data_row_target_table << Oj.load(raw.data).merge({"#{e[:target_table]}_row_id" => raw.row_id}) }   
              end  
            end
            case e[:join_type]
              when "inner"
                data_row_source_table.each do |data_source_table|
                  row_1 = data_source_table[target_field]
                  data_row_target_table.each do |data_target_table|
                    if row_1 ==  data_target_table[target_field]
                      output.each do |arr|
                        if arr.has_key?(source_field) && arr.has_value?(row_1)
                          arr.merge(data_target_table)
                          arr["row_id"] << data_target_table["#{e[:target_table]}_row_id"]
                        end
                      end
                    end
                  end
                end
              when "left"
                temp = []
                not_found = Column.where(table_id:  target_table).reduce({}) { |init, v| init.merge({"#{v.name}": ""}) }
                data_row_source_table.each do |data_source_table|
                  row_1 = data_source_table[source_field]
                  data_row_target_table.each do |data_target_table|
                    if row_1 ==  data_target_table[target_field]
                      output.each_with_index do |arr, key|
                        if arr.has_key?(source_field) && arr.has_value?(row_1)
                          arr.merge(data_source_table.merge(data_target_table))
                          arr["row_id"] << data_target_table["#{e[:target_table]}_row_id"]
                          temp << key
                        end
                      end
                    end
                  end
                end
                output.each_with_index { |v,k| v.merge(not_found) if temp.uniq.include?(k) == false } unless temp.empty?
              when "right"
                temp = []
                not_found = Column.where(table_id:  source_table).reduce({}) { |init, v| init.merge({"#{v.name}": ""}) }
                data_row_target_table.each do |data_target_table|
                  row_2 = data_target_table[target_field]
                  data_row_source_table.each do |data_source_table|
                    if data_source_table[source_field] ==  row_2
                      output.each_with_index do |arr, key|
                        if arr.has_key?(row_2) && arr.has_value?(target_field)
                          arr.merge(data_target_table.merge(data_source_table))
                          arr["row_id"] << data_source_table["#{e[:source_table]}_row_id"]
                          temp << key
                        end
                      end
                    end
                  end
                end
                output.each_with_index { |v,k| v.merge(not_found) if temp.uniq.include?(k) == false } unless temp.empty?
            end
          end  
        end
      end
    end
    output
  end

  def get_data_by_hash_clause(condition, rules, table_id, connect)
    Octopus.using(connect.database.to_sym) do
      raws = nil
      hash = Row.extract_conditon_join_by_rules(condition, rules, table_id)
      table_id = hash[:table_id]
      new_hash = {}
      new_hash[:condition]= hash[:condition]
      new_hash[:rules] = []
      hash[:rules].each do |e| 
        column = Column.find_by_name(e[:column_name])
        new_hash[:rules] << e if table_id == column.table_id && e[:value].present? 
      end  
      unless new_hash[:rules].empty?
        arel_query = QueryBuilderParseToArelQuery.new(new_hash, table_id, connect).to_query
        return [] if arel_query.empty?
        rows = Row.find_by_sql(arel_query)
        raws = Raw.where(row_id: rows.map(&:id))
      end
      raws
    end
  end  

end

