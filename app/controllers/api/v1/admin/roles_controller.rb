class Api::V1::Admin::RolesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_role_by_params, only: [:show, :destroy]

  def index
    render json: @project.roles
  end

  def show
    render json: @role
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role
    else
      render json: {
        message: @role.errors.full_messages
      }, status: 422
    end
  end

  def create_multiple
    roles = roles_params[:roles].map { |e| Role.new(e) }
    if roles.each(&:valid?) && roles.all? { |e| e.errors.full_messages == [] }
      roles.each(&:save)
    else
      render json: {
        data: roles,
        message: roles.map.with_index { |e, index| { index: index, full_messages: e.errors.full_messages } }
      }, status: 422
      return
    end
    render json: roles
  end

  def destroy
    @role.destroy
    render_destroy_success
  end

  private

  def role_params
    params.require(:role).permit(:role_type_id, :user_id)
  end

  def roles_params
    params.permit(roles: [:role_type_id, :user_id])
  end

  def render_destroy_success
    render json: {
      message: 'Remove role successfully'
    }
  end

  def render_error_role_not_found
    render json: {
      message: 'Role not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message:'Project not found'
    }, status: 404
  end

  def set_role_by_params
    @role = Role.find_by(id: params[:id])
    render_error_role_not_found if @role.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end
end
