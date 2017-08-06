class Api::V1::Admin::OperationsController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_page_by_params
  before_action :set_operation_by_params, only: [:show, :update, :destroy]
  # before_action :set_stage_by_params, only: [:index]

  def show
    render json: @operation
  end

  def index
    @operations = @page.operations
    render json: @operations
  end

  def create
    @operation = @page.operations.new(operation_params)
    if @operation.save
      render json: @operation
    else
      render json:{
        message: @operation.errors.full_messages
      }, status: 422
    end
  end

  def update
    @operation.assign_attributes(operation_params)
    if @operation.save
      render json: @operation
    else
      render json:{
        message: @operation.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @operation.destroy
    render_destroy_success
  end

  private

  def operation_params
    params.require(:operation)
          .permit(:name, :stage, :query, :ds_name, :condition, :per_page, :is_array)
  end

  def set_operation_by_params
    @operation = Operation.find_by(id: params[:id], page_id: params[:page_id])
    render_error_operation_not_found if @operation.nil?
  end

  def set_page_by_params
    @page = Page.find_by(id: params[:page_id], project_id: params[:project_id])
    render_error_page_not_found if @page.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def set_stage_by_params
    @stage = params[:stage]
    render_error_missing_stage_params if @stage.nil?
  end

  def render_error_operation_not_found
    render json: {
      message: 'Operation not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

  def render_error_page_not_found
    render json: {
      message: 'Page not found'
    }, status: 404
  end

  def render_error_missing_stage_params
    render json: {
      message: 'Stage params not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
end
