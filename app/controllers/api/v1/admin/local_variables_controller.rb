class Api::V1::Admin::LocalVariablesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_page_by_params
  before_action :set_local_variable_by_params, only: [:show, :update, :destroy]

  def show
    render json: @local_variable
  end

  def index
    @local_variables = @page.local_variables
    render json: @local_variables
  end

  def create
    @local_variable = @page.local_variables.new(local_variable_params)
    if @local_variable.save
      render json: @local_variable
    else
      render json: {
        message: @local_variable.errors.full_messages
      }, status: 422
    end
  end

  def create_multiple
    params_added_page = local_variables_params[:local_variables].each { |e| e[:page_id] = @page.id }
    local_variables = params_added_page.map { |e| LocalVariable.new(e) }
    if local_variables.each(&:valid?) && local_variables.all? { |e| e.errors.full_messages == [] }
      local_variables.each(&:save)
    else
      render json: {
        data: local_variables,
        message: local_variables.map.with_index { |e, index| {index: index, full_messages: e.errors.full_messages} }
      }, status: 422
      return
    end
    render json: local_variables
  end

  def update
    @local_variable.assign_attributes(local_variable_params)
    if @local_variable.save
      render json: @local_variable
    else
      render json: {
        message: @local_variable.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @local_variable.destroy
    render_destroy_success
  end

  private

  def local_variable_params
    params.require(:local_variable).permit(:name, :value, :variable_type)
  end

  def local_variables_params
    params.permit(local_variables: [:name, :value, :variable_type])
  end

  def set_local_variable_by_params
    @local_variable = LocalVariable.find_by(id: params[:id], page_id: params[:page_id])
    render_error_local_variable_not_found if @local_variable.nil?
  end

  def set_page_by_params
    @page = Page.find_by(id: params[:page_id], project_id: params[:project_id])
    render_error_page_not_found if @page.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def render_error_local_variable_not_found
    render json: {
      message: 'Local_variable not found'
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

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
end
