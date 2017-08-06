class QueryBuilderParseToArelQuery
  def initialize(hash, table_id, connect)
    @hash =  hash.with_indifferent_access
    @table_id = table_id
    @connect = connect
  end

  def to_query
    convert_to_query(@hash, @table_id, @connect)
  end

  private

  def convert_to_query(hash, table_id, connect, output_query = nil)
    return "" if hash[:condition] == nil
    condition = hash[:condition].downcase
    Octopus.using(connect.database.to_sym) do
      hash[:rules].each do |e|
        if output_query.nil?
          output_query = RuleQBToArelQuery.new(e, table_id, connect).to_query
        else
          output_query = output_query.or(RuleQBToArelQuery.new(e, table_id, connect).to_query)
          if condition == "and" && (e == hash[:rules].last)
            return Row.joins(:cells).where(output_query).group("rows.id").having("count('rows.id') = #{hash[:rules].size}").to_sql
          end
        end
      end
      return Row.joins(:cells).where(output_query).to_sql
    end
  end
end
