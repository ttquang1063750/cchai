class LogChangementQuery
   OPERATOR = {
    not_equal: "!=",
    equal: "=",
    greater: ">",
    less: "<",
    less_or_equal: "<=",
    greater_or_equal: ">=",
    in: "IN"
  }.freeze

  def initialize(hash, connect)
    @hash =  hash.with_indifferent_access
    @connect = connect
  end

  def to_query
    convert_to_log_query @hash, @connect
  end

  private

  def convert_to_log_query hash, connect, output_query = nil
    return "" if hash[:condition] == nil
    output_query = []
    Octopus.using(connect.database.to_sym) do
      hash[:rules].each do |rule|
        if rule[:column_name] == "created_at" || rule[:column_name] == "updated_at"
           output_query << "Date(#{rule[:column_name]}) #{OPERATOR[rule[:operator].to_sym]} Date('#{rule[:value]}')"
        else  
          output_query << "#{rule[:column_name]} #{OPERATOR[rule[:operator].to_sym]} '#{rule[:value]}' "
        end
        output_query << " #{hash[:condition]} " unless rule == hash[:rules].last
      end
      output_query = output_query.join
    end
    output_query
  end
end

