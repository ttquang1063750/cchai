class Api::V1::Admin::SessionVariablesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_session_variable_by_params, only: [:show, :update, :destroy]

  def show
    render json: @session_variable
  end

  def index
    @session_variables = @project.session_variables
    render json: @session_variables
  end

  def create
    @session_variable = @project.session_variables.new(session_variable_params)
    if @session_variable.save
      render json: @session_variable
    else
      render json: {
        message: @session_variable.errors.full_messages
      }, status: 422
    end
  end

  def create_multiple
    params_added_project = session_variables_params[:session_variables].each { |e| e[:project_id] = @project.id }
    session_variables = params_added_project.map { |e| SessionVariable.new(e) }
    if session_variables.each(&:valid?) && session_variables.all? { |e| e.errors.full_messages == [] }
      session_variables.each(&:save)
    else
      render json: {
        data: session_variables,
        message: session_variables.map.with_index { |e, index| {index: index, full_messages: e.errors.full_messages} }
      }, status: 422
      return
    end
    render json: session_variables
  end

  def update
    @session_variable.assign_attributes(session_variable_params)
    if @session_variable.save
      render json: @session_variable
    else
       render json: {
        message: @session_variable.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @session_variable.destroy
    render_destroy_success
  end

  private

  def session_variable_params
    params.require(:session_variable).permit(:name, :value, :variable_type)
  end

  def session_variables_params
    params.permit(session_variables: [:name, :value, :variable_type])
  end

  def set_session_variable_by_params
    @session_variable = SessionVariable.find_by(id: params[:id], project_id: params[:project_id])
    render_error_session_variable_not_found if @session_variable.nil?
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

  def render_error_session_variable_not_found
    render json: {
      message: 'Session_variable not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
end
