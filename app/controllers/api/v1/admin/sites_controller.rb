class Api::V1::Admin::SitesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_site_by_params, only: [:show, :destroy]
  before_action :check_user_exists_in_site, only: [:create]

  def index
    render json: @project.sites
  end

  def show
    render json: @site
  end

  def create
    @site = Site.new(site_params)
    if @site.save
      render json: @site
    else
      render json: {
        message: @site.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @site.destroy
    render_destroy_success
  end

  private

  def site_params
    params.require(:site).permit(:site_info_id, :user_id)
  end

  def set_site_by_params
    @site = Site.find_by(id: params[:id])
    render_error_site_not_found if @site.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def check_user_exists_in_site
   render_user_was_exists_in_other_site if @project.sites.find_by(user_id: params[:site][:user_id]).present?
  end  

   def render_destroy_success
    render json: {
      message: 'Remove site successfully'
    }
  end

  def render_error_site_not_found
    render json: {
      message: 'Site not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message:'Project not found'
    }, status: 404
  end

  def render_user_was_exists_in_other_site
     render json: {
      message:'User was exists in other site'
    }, status: 404
  end  
end
