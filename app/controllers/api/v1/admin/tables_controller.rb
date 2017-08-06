class Api::V1::Admin::TablesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_table_by_params, only: [:show, :update, :destroy]
  before_action :set_table_count_and_column_count_by_params, only: [:create, :update, :destroy]
  before_action :set_colums_by_params, only: [:update]
  before_action :set_check_table, only: [:update, :destroy] # Check table exist in operation

  def show
    render json: @table, include: 'columns'
  end

  def index
    @tables = @database ? Table.using(@database.database.to_sym).all : Table.all
    @data = []
    @tables.reduce({}) do |init, e|
      @data << { id: e.id, attributes: { name: e.name }, relationships: { columns: { data: e.columns } } }
    end  
    render json: { data: @data }
  end

  def create
    @table = Table.using(@database.database.to_sym).new(table_params)
    @table_count = Table.using(@database.database.to_sym).find_by_name('table_count')
    Table.transaction do
      if @table.save
        # Create row data in table_count when create new table
        create_row_data_table_count(@database, @table.name, @columns_count, @table_count.id)
        render json: @table
      else
        render json: {
          message: @table.errors.full_messages
        }, status: 422
      end
    end
  end

  def update
    if @table.name != 'table_count' || @check_table == false
      Table.transaction do
        origin_table_name = @table.name
        @table.assign_attributes(table_params)
        if @table.save
          # Update column name when update table
          update_column_name(@database, @columns, @columns_count, origin_table_name, @table.name)
          render json: @table
        else
          render json: {
            message: @table.errors.full_messages
          }, status: 422
        end
      end
    else
      render_error_table_cant_not_update
    end        
  end

  def destroy
    if @table.name != 'table_count' || @check_table == false
      cells = []
      Octopus.using(@database.database.to_sym) do
        @columns_count.each do |e|
          cell = Cell.find_by(value: @table.name, column_id: e.id)
          if cell.present?
            cell_ids = Cell.where(row_id: cell.row_id).map(&:id)
            Cell.destroy(cell_ids)
            Row.destroy(cell.row_id)
          end
        end
        @table.destroy
      end
      render_destroy_success
    else
      render_error_table_cant_not_destroy
    end
  end

  private

  def create_row_data_table_count(connect, table_name, columns_count, table_count_id)
    Octopus.using(connect.database.to_sym) do
      Row.transaction do
        row = Row.create  unique_id: SecureRandom.uuid, table_id: table_count_id
        Cell.transaction do
          value = [table_name, 0];
          columns_count.each_with_index { |e, i| Cell.create value: value[i], column_id: e.id, row_id: row.id }
        end  
        Raw.transaction do
          data = Oj.dump(Cell.get_cells_value(Cell.where(row_id: row.id)))
          Raw.create data: data, table_id: table_count_id, row_id: row.id
        end
      end
    end
  end  

  def update_column_name(connect, columns, columns_count, origin_table_name, new_table_name)
    Octopus.using(connect.database.to_sym) do
      Column.transaction do
        columns.each do |e|
          e.name.sub! origin_table_name, new_table_name
          e.save
        end
      end
      Cell.transaction do
        cell = Cell.find_by(value: origin_table_name, column_id: columns_count.map(&:id))
        unless cell.nil?
          cell.value = new_table_name
          cell.save
        end
        Raw.transaction do
          data = Oj.dump(Cell.get_cells_value(Cell.where(row_id: cell.row_id)))
          Raw.update(Raw.find_by(row_id: cell.row_id), data: data)
        end
      end  
    end
  end  

  def table_params
    params[:table][:project_id] = @project.id
    params.require(:table).permit(:name, :project_id)
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    @database = DbConnect.find_by(project_id: @project.id)
    render_error_project_not_found if @project.nil?
  end
  
  def set_table_by_params
    @table = Table.using(@database.database.to_sym).find_by(id: params[:id], project_id: params[:project_id])
    render_error_table_not_found if @table.nil?
  end


  def set_table_count_and_column_count_by_params
    Octopus.using(@database.database.to_sym) do
      @table_count = Table.find_by_name('table_count')
      @columns_count = Column.where(table_id: @table_count.id)
    end
  end

  def set_colums_by_params
    @columns = Column.using(@database.database.to_sym).where(table_id: @table.id)
  end

  def set_check_table
    @check_table = false
    @operation = Operation.all
    @operation.each do |e|
      if e.stage == 'init' && e.ds_name == @table.name
        @check_table = true
      elsif e.stage == 'join'
        query = Oj.load(e.query).with_indifferent_access
        query[:rules].each { |e| @check_table = true if e[:sourceTable] == @table.name || e[:targetTable] == @table.name }
      end   
    end  
  end  

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

  def render_error_table_not_found
    render json: {
      message: 'Table not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
  
  def render_error_table_cant_not_destroy
    render json: {
      message: 'Table can not destroy'
    }, status: 404
  end

  def render_error_table_cant_not_update
    render json: {
      message: 'Table can not update'
    }, status: 404
  end
end
