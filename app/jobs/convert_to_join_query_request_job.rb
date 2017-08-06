class ConvertToJoinQueryRequestJob < ApplicationJob

  def perform(id, query)
    join_query = JoinQueryVer2.new(Oj.load(query), id).to_query
    return [] if join_query.empty?
    @operation = Operation.find_by_id(id)
    @page = Page.find_by_id(@operation.page_id)
    @table = Table.find_by(name: @operation.ds_name, project_id: @page.project_id)
    @table_columns = @table.columns
    new_array = Page.change_value_csv(@table_columns, join_query)
    csv_string= Page.to_csv(@table_columns, new_array, @table, @operation)
  end
end