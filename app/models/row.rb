class Row < ApplicationRecord
  belongs_to :table
  has_many :columns, through: :table
  has_many :cells, dependent: :destroy
  has_one :raw, dependent: :destroy

  validates_presence_of :table

  def required_columns
    columns.where(required: true).pluck(:id)
  end

  # def get_value
  #   if self.id != nil
  #     cells.reduce({}) do |init, e|
  #       init.merge({e.column.name.to_sym => e.get_value})
  #     end.merge({row_id: self.id, table_id: self.table.id})
  #   else
  #       columns.reduce({}) do |init,e|
  #         init.merge({e.name.to_sym =>  {column_id: e.id , value: ""}})
  #       end.to_h.merge({row_id: "", table_id: self.table.id})
  #   end
  # end

  class << self
    def create_or_update(params, connect)
      params[:row_id].to_s.empty? ? create_record(params, connect) : update_record(params, connect)
    end

    def create_record(params, connect)
      row = nil
      table = Table.using(connect.database.to_sym).find_by_id(params[:table_id])
      row = Row.using(connect.database.to_sym).create! unique_id: SecureRandom.uuid, table_id: table.id
      Row.using(connect.database.to_sym).transaction do
        Octopus.using(connect.database.to_sym) do
          # Update cell
          # Update table_count
          # When create record
          # Find table_count
          table_count = Table.find_by_name('table_count')
          columns = table_count.columns
          cell = Cell.find_by(value: table.name, column_id: columns.map(&:id)) # Find cell table name
          column_table_count = Column.find_by(table_id: table_count.id, name: 'count_value') # Find column need update
          cell_table_count = Cell.find_by(row_id: cell.row_id, column_id: column_table_count.id) # Find cell need update
          Cell.transaction do
            Cell.update(cell_table_count.id, value: (cell_table_count.value.to_i + 1))
            Raw.transaction do
              data = Oj.dump(Cell.get_cells_value(Cell.where(row_id: cell.row_id)))
              Raw.update(Raw.find_by(row_id: cell.row_id), data: data)
            end
          end
        end
        params[:row_data].each do |e|
          data = {}
          e.each do |key, value|
            column = Column.using(connect.database.to_sym).find_by(table_id: params[:table_id], name: key.to_s)
            Cell.using(connect.database.to_sym).transaction do
              Cell.using(connect.database.to_sym).create!(data.merge({row_id: row.id, column_id: column.id, value: value}))
            end
            Project.changement_create(params, column, value, connect) # Create log changement
          end
        end
        # Create data table raw
        # When create record
        data = Oj.dump(Cell.get_cells_value(Row.using(connect.database.to_sym).joins(cells: :column).where(id: row.id).distinct.first.cells))
        Raw.using(connect.database.to_sym).create! table_id: params[:table_id], row_id: row.id, data: data
      end
      row
    end

    def update_record(params, connect)
      row = nil
      Row.using(connect.database.to_sym).transaction do
        row = Row.using(connect.database.to_sym).find_by_id(params[:row_id])
        params[:row_data].each do |e|
          e.each do |key, value|
            column = Column.using(connect.database.to_sym).find_by(table_id: params[:table_id], name: key.to_s)
            cell = Cell.using(connect.database.to_sym).find_by(row_id: params[:row_id], column_id: column.id)
            Cell.using(connect.database.to_sym).transaction do
              Cell.using(connect.database.to_sym).update(cell.id, value: value)
            end
            Project.changement_update(params, cell, value, connect) # Create log changement
          end
        end
        # Update data table raw
        # When update record
        data = Oj.dump(Cell.get_cells_value(Row.using(connect.database.to_sym).joins(cells: :column).where(id: row.id).distinct.first.cells))
        raw = Raw.using(connect.database.to_sym).find_by(row_id: row.id)
        Raw.using(connect.database.to_sym).update(raw.id, data: data)
      end
      row
    end

    def delete_row(item, connect, info)
      item[:row_id].each do |e|
        cell_delete = Cell.using(connect.database.to_sym).where(row_id: e)
        raw_delete = Raw.using(connect.database.to_sym).find_by(row_id: e)
        cell_delete.each { |cell| Cell.using(connect.database.to_sym).delete(cell.id) }
        Project.changement_delete(raw_delete, connect, info) # Create log delete
        Raw.using(connect.database.to_sym).delete(raw_delete.id)
        Row.using(connect.database.to_sym).delete(e)
      end
    end

    def query(condition)
      self.joins(:cells).where(condition).distinct
    end

    def extract_row_params_from_value(value, client, role_name, page_name)
      hash = {}
      hash[:row_id] = value[:row_id]
      hash[:table_id] = value[:table_id]
      hash[:row_data] = value.to_a.flatten.select { |e| e.is_a?(Hash) }
      hash[:client] = client
      hash[:role_name] = role_name.join(', ')
      hash[:page_name] = page_name
      hash
    end

    def extract_row_ids_from_value(value)
      hash = {}
      hash[:row_id] = value[:row_id]
      hash
    end

    def extract_operation_params_from_query(query_condition, table_id)
      query_condition = Oj.load(query_condition).with_indifferent_access
      hash = {}
      hash[:condition] = query_condition[:condition]
      hash[:rules] = query_condition.to_a.flatten.select { |e| e.is_a?(Hash) }
      hash[:table_id] = table_id
      hash
    end

    def extract_conditon_join_by_rules(condition, rules, table_id)
      hash = {}
      hash[:condition] = condition
      hash[:rules] = rules.to_a.flatten.select { |e| e.is_a?(Hash) }
      hash[:table_id] = table_id
      hash
    end
  end
end

