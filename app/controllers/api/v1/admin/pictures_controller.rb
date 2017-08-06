class Api::V1::Admin::PicturesController < Api::V1::AdminController
  before_action :set_project_by_params
  before_action :set_picture_by_params, only: [:show, :update, :destroy]

  def show
    render json: @picture
  end

  def index
    if @project.present?
      @pictures = @project.pictures
    else
      @pictures = Picture.where(project_id: nil)
    end    
    render json: @pictures
  end

  def create
    if @project.present?
      @picture = @project.pictures.new(picture_params)
    else
      @picture = Picture.new(picture_params)
    end    
    begin
      if @picture.save
        render json: @picture
      else
        render json: {
          message: @picture.errors.full_messages
        }, status: 422
      end
    rescue
      render_wrong_image_data
    end
  end

  def update
    @picture.assign_attributes(picture_params)
    begin
      if @picture.save
        render json: @picture
      else
        render json: {
          message: @picture.errors.full_messages
        }, status: 422
      end
    rescue
      render_wrong_image_data
    end
  end

  def destroy
    @picture.destroy
    render_destroy_success
  end

  private

  def render_destroy_success
    render json: {
      message: 'Destroyed task successful'
    }
  end

  def render_error_picture_not_found
    render json: {
      message: 'Picture not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

  def render_wrong_image_data
    render json: {
      message: 'Wrong image data'
    }, status: 400
  end

  def set_picture_by_params
    if params[:project_id].present?
      @picture = Picture.find_by id: params[:id], project_id: params[:project_id]
    else
      @picture = Picture.find_by id: params[:id], project_id: nil
    end  
    render_error_picture_not_found if @picture.nil?
  end

  def set_project_by_params
    if params[:project_id].present?
      @project = Project.find_by_id params[:project_id]
      render_error_project_not_found if @project.nil?
    end
  end

  def picture_params
    params.permit(:image_data, :name)
  end
end
