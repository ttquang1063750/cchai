class RuleQBToArelQuery
  OPERATOR_MATCH = {
    not_equal: "not_eq",
    equal: "eq",
    greater: "gt",
    less: "lt",
    less_or_equal: "lteq",
    greater_or_equal: "gteq",
    in: "in"
  }.freeze

  def initialize(rule, table_id, connect)
    Octopus.using(connect.database.to_sym) do
      @column = Column.find_by(name: rule[:column_name], table_id: table_id)
      @column_id = @column.id
      @cells = Cell.arel_table
      @operator = rule[:operator]
      @value = rule[:value]
    end
  end

  def to_query
    @cells[:column_id].eq(@column_id).and(operator_value_converter)
  end

  private

  def operator_value_converter
    @cells[:value].send(OPERATOR_MATCH[@operator.to_sym], @value)
  end
end
