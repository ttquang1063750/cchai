class Api::V1::Admin::PagesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_page_by_params, only: [:show, :update, :destroy]
  before_action :check_layout_valid, only: [:create, :update]

  def show
    render json: @page
  end

  def index
    @pages = @project.pages
    render json: @pages
  end

  def create
    @page = @project.pages.new(page_params)
    if @page.save
      render json: @page
    else
      render json:{
        message: @page.errors.full_messages
      }, status: 422
    end
  end

  def update
    @page.assign_attributes(page_params)
    if @page.save
      render json: @page
    else
      render json:{
        message: @page.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @page.destroy
    render_destroy_success
  end

  private

  def page_params
    params.require(:page).permit(:name, :sluck, :layout)
  end

  def set_page_by_params
    @page = Page.find_by(id: params[:id], project_id: params[:project_id])
    render_error_page_not_found if @page.nil?
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

  def check_layout_valid
    begin
      Oj.load(page_params[:layout])
    rescue Oj::ParseError
      render json: { message: 'Invalid layout' }, status: 422 and return
    end
  end
end
