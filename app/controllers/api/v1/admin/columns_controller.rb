class Api::V1::Admin::ColumnsController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_table_by_params
  before_action :set_column_by_params, only: [:show, :update, :destroy]

  def show
    render json: @column
  end

  def index
    @columns = @table.columns
    render json: @columns
  end

  def create
    @column = @table.columns.new(column_params)
    if @column.save
      render json: @column
    else
      render json: {
        message: @column.errors.full_messages
      }, status: 422
    end
  end

  def update
    @column.assign_attributes(column_params)
    if @column.save
      render json: @column
    else
      render json: {
        message: @column.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @column.destroy
    render_destroy_success
  end

  private

  def column_params
    params[:column][:name].insert(0, "#{@table.name}_")
    params.require(:column).permit(:name, :content_type, :condition, :required)
  end

  def set_column_by_params
    @column = Column.using(@database.database.to_sym).find_by(table_id: params[:table_id], id: params[:id])
    render_error_column_not_found if @column.nil?
  end

  def set_table_by_params
    @table = Table.using(@database.database.to_sym).find_by(id: params[:table_id])
    render_error_table_not_found if @table.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    @database = DbConnect.find_by_project_id(@project.id)
    render_error_project_not_found if @project.nil?
  end

  def render_error_column_not_found
    render json: {
      message: 'Column not found'
    }, status: 404
  end

  def render_error_table_not_found
    render json: {
      message: 'Table not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
end
