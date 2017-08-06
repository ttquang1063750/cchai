class Api::V1::Admin::UsersController < Api::V1::AdminController
  before_action :set_user_by_params, only: [:show, :update, :destroy]
  before_action :pagination, only: [:index, :search]
  def index
    @users = User.page(@page_number || 1).per(@page_size || 10)
    render json: @users, meta: {
                              pagination: {
                                total_objects: User.count,
                                per_page: @page_size || 10,
                                total_pages: @users.total_pages,
                                current_page: @users.current_page
                              } 
    }
  end

  def show
    render json: @user
  end

  def search
    @users = User.all.search_for(params[:q])
                 .page(@page_number || 1)
                 .per(@page_size || 10)
    render json: @users, meta: {
                            pagination: {
                              total_objects: @users.count,
                              per_page: @page_size,
                              total_pages: @users.total_pages,
                              current_page: @users.current_page
                            }
    }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: {
        message: @user.errors.full_messages
      }, status: 422
    end
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save
      render json: @user
    else
      render json: {
        message: @user.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @user.destroy
    render_destroy_success
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def render_destroy_success
    render json: {
      message: "Destroyed user account with uid #{@user.uid} successful"
    }
  end

  def render_error_user_not_found
    render json: {
      message: 'User not found'
    }, status: 404
  end

  def set_user_by_params
    @user = User.find_by_id(params[:id])
    render_error_user_not_found if @user.nil?
  end

  def pagination
    return unless params[:page].present? && params[:size].present?
    @page_number = params[:page]
    @page_size = params[:size]
  end

  def filter_by_role_type
    @filter_role = params[:filter_by_role_type] if params[:filter_by_role_type].present?
  end
end
