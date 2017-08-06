class OperationOneTableJob < ApplicationJob

  def perform(table, operation, client_query_condition, headers, database)
    store = Page.get_store_for_page_show(Store.new, operation, client_query_condition, table, nil, database)
    datas = store.db[operation.name]
    new_datas = Page.change_value_csv(table.columns, datas)
    csv_string= Page.to_csv(headers, new_datas, table, operation)
  end

end
