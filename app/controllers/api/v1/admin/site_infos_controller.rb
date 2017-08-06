class Api::V1::Admin::SiteInfosController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_site_info_by_params, only: [:show, :update, :destroy, :users]
  
  def show
    render json: @site_info
  end

  def index
    @site_infos = @project.site_infos
    render json: @site_infos
  end

  def create
    @site_info = @project.site_infos.new(site_info_params)
    if @site_info.save
      render json: @site_info
    else
      render json:{
          message: @site_info.errors.full_messages
      }, status: 422
    end
  end

  def update
    @site_info.assign_attributes(site_info_params)
    if @site_info.save
      render json: @site_info
    else
      render json: {
          message: @site_info.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @site_info.destroy
    render_destroy_success
  end

  def users
    @users = @site_info.users.includes(:site_infos, :sites)
    render json: @users, each_serializer: Api::V1::Admin::SiteInfoUsersSerializer,
                         project_id: @project.id,
                         site_info_id: @site_info.id
  end

  private

  def site_info_params
    params.require(:site_info).permit(:number, :name, :remarks, :addresss, :tel, :fax)
  end

  def set_site_info_by_params
    @site_info = SiteInfo.find_by(id: params[:id], project_id: params[:project_id])
    render_error_site_info_not_found if @site_info.nil?
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

  def render_error_site_info_not_found
    render json: {
      message: 'Site info not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: 'Destroy successful'
    }
  end
end
