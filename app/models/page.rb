class Page < ApplicationRecord
  belongs_to :project

  has_many :operations, dependent: :destroy
  has_many :local_variables, dependent: :destroy
  has_many :log_changement

  %i(name sluck layout).each do |e|
    validates_presence_of e
  end
  validates :name, uniqueness: { scope: :project_id, case_sensitive: false }
  validates :sluck, uniqueness: { scope: :project_id, case_sensitive: false }

  def layout_filter_by_user(user)
    FilterNestedHash.new(self.layout, role: user.user_role_types_by_project(self.project_id))
  end

  class << self

    def get_store_for_page_show(store, operation, client_query_condition, table, order_by, connect)
      table.present? ? table_id = table.id : table_id = nil
      operation.query = case operation.stage
      when 'join'
        client_query_condition
      else
        Row.using(connect.database.to_sym).extract_operation_params_from_query(client_query_condition, table_id).to_json
      end
      operation.insert_data_to_store(store, connect, order_by)
    end

    def to_csv(headers, new_array, table, operation)
      path = File.join 'public', 'uploads', 'csv_export', table.project_id.to_s
      FileUtils.mkdir_p(path) unless File.exist?(path)
      if operation.background_mode == 1
        file = CSV.open(File.join(path, "#{operation.id}.csv"), 'wb') do |csv|
          create_csv(headers, new_array, csv)
        end  
      else
        file = CSV.generate(headers: true) do |csv|
          create_csv(headers, new_array, csv)
        end 
      end   
    end

    def change_value_csv(table_columns, datas)
      table_columns.each do |column|
        conditons = column.condition
        if conditons.present?
          datas.each do |data|
            Oj.load(conditons).each { |conditon| Page.check_column_type_export(column, conditon.with_indifferent_access, data) } if data[column.name].present?
          end
        end
      end
      datas
    end

    def check_column_type_export(column, column_condition, data)
      column_name = column.name
      from = column_condition[:from]
      by = column_condition[:by]
      to = column_condition[:to]
      case column.content_type
      when 'string'
        data[column_name] = to if by == '==' && data[column_name] == from
      when 'integer'
        data[column_name] = to if eval([data[column_name].to_i, by, from].join) == true
      end
    end

    def create_csv(headers, new_array, csv)
      attributes = []
      headers.to_a.each { |header| header["value2"].present? ? attributes << header["value2"] : attributes << header["value1"] }
      csv << attributes
      new_array.each do |item|
        arr = []
        headers.to_a.each do |header|
          item.to_a.each { |elements| arr <<  elements[1] if elements[0] == header["value1"] }
        end
        csv << arr
      end
    end

  end  

end
