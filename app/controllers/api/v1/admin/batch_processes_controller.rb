class Api::V1::Admin::BatchProcessesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_batch_process_by_params, only: [:show, :update, :destroy]

  def show
    render json: @batch_process
  end

  def index
    @batch_processes = @project.batch_processes
    render json: @batch_processes
  end

  def create
    @batch_process = @project.batch_processes.new(batch_process_params)
    if @batch_process.save
      render json: @batch_process
    else
      render json: {
          message: @batch_process.errors.full_messages
      }, status: 422
    end
  end


  def update
    @batch_process.assign_attributes(batch_process_params)
    if @batch_process.save
      render json: @batch_process
    else
      render json: {
          message: @batch_process.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @batch_process.destroy
    render_destroy_success
  end

  private

  def batch_process_params
    params[:batch_process][:executed_at] =  Time.parse(params[:batch_process][:executed_at]).utc.iso8601 
    params.require(:batch_process)
          .permit(:name, :enable, :repeat_time, :operation, :batch_process_type, :executed_at)
  end

  def set_batch_process_by_params
    @batch_process = BatchProcess.find_by(id: params[:id], project_id: params[:project_id])
    render_error_batch_process_not_found if @batch_process.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def render_error_project_not_found
    render json: {
        message: 'Project not found'
    }, status: 404
  end

  def render_error_batch_process_not_found
    render json: {
        message: 'Batch process not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
        message: 'Destroy successful'
    }
  end
end

