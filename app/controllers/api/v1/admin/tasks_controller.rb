class Api::V1::Admin::TasksController < Api::V1::AdminController
  before_action :set_task_by_params, only: [:show, :update, :destroy]

  def show
    render json: @task
  end

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task
    else
      render json: @task, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def update
    @task.assign_attributes(task_params)
    if @task.save
      render json: @task
    else
      render json: @task, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    @task.destroy
    render_destroy_success
  end

  private

  def render_destroy_success
    render json: {
      message: "Destroyed task with id #{@task.id} successful"
    }
  end

  def render_error_task_not_found
    render json: {
      message: 'Task not found'
    }, status: 404
  end

  def set_task_by_params
    @task = Task.find_by_id params[:id]
    render_error_task_not_found if @task.nil?
  end

  def task_params
    params.require(:task).permit(:name, :deadline, :project_id, :description)
  end
end
