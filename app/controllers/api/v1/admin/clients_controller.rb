class Api::V1::Admin::ClientsController < Api::V1::AdminController
  before_action :set_client_by_params, only: [:show, :update, :destroy]
  before_action :pagination, only: [:index]

  def show
    render json: @client
  end

  def index
    @clients = Client.includes(:projects).all.page(@page_number || 1).per(@page_size || 10)
    render json: @clients,  meta: { 
                              pagination: { 
                                total_objects: Client.count,
                                per_page: @page_size,
                                total_pages: @clients.total_pages,
                                current_page: @clients.current_page
                              } 
                            }
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      render json: @client
    else
      render json: {
        message: @client.errors.full_messages
      }, status: 422
    end
  end

  def update
    @client.assign_attributes(client_params)
    if @client.save
      render json: @client
    else
      render json: {
        message: @client.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @client.destroy
    render_destroy_success
  end

  private

  def render_destroy_success
    render json: {
      message: "Destroyed client with id #{@client.id} successful"
    }
  end

  def render_error_client_not_found
    render json: {
      message: 'Client not found'
    }, status: 404
  end

  def set_client_by_params
    @client = Client.find_by_id params[:id]
    render_error_client_not_found if @client.nil?
  end

  def client_params
    params.require(:client).permit(:name)
  end

  def pagination
    return unless params[:page].present? && params[:size].present?
    @page_number = params[:page]
    @page_size = params[:size]
  end  
end
