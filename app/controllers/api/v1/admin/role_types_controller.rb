class Api::V1::Admin::RoleTypesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_role_type_by_params, only: [:show, :update, :destroy, :users]
  before_action :check_roles_params_correct, only: [:creates]
  def show
    render json: @role_type
  end

  def index
    @role_types = @project.role_types
    render json: @role_types
  end

  def create
    @role_type = @project.role_types.new(role_type_params)
    if @role_type.save
      render json: @role_type
    else
      render json:{
          message: @role_type.errors.full_messages
      }, status: 422
    end
  end

  def creates
    role_types = []
    params[:roles].split(',').each { |e| role_types << (RoleType.new name: e, project_id: params[:project_id]) }
    if role_types.all?(&:valid?)
      role_types.each(&:save)
    else
      render json: {
        data: role_types,
        message: role_types.map.with_index { |e, index| { index: index, full_messages: e.errors.full_messages } }
      }, status: 422
      return
    end
    render json: role_types
  end

  def update
    @role_type.assign_attributes(role_type_params)
    if @role_type.save
      render json: @role_type
    else
      render json: {
          message: @role_type.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @role_type.destroy
    render_destroy_success
  end

  def users
    @users = @role_type.users.includes(:role_types, :roles)
    render json: @users, each_serializer: Api::V1::Admin::RoleTypeUsersSerializer,
                         project_id: @project.id,
                         role_type_id: @role_type.id
  end

  private

  def role_type_params
    params.require(:role_type).permit(:name)
  end

  def set_role_type_by_params
    @role_type = RoleType.find_by(id: params[:id], project_id: params[:project_id])
    render_error_role_type_not_found if @role_type.nil?
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

  def render_error_role_type_not_found
    render json: {
      message: 'Role type not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end

  def render_error_roles_params_missing
    render json: {
      message: 'Missing roles params'
    }, status: 400
  end

  def check_roles_params_correct
    render_error_roles_params_missing unless params[:roles].present?
  end
end
