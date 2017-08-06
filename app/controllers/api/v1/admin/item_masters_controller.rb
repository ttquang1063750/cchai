class Api::V1::Admin::ItemMastersController < Api::V1::AdminController
  before_action :set_item_master_by_params, only: [:show, :update, :destroy, :clone]
  before_action :check_item_master_by_params, only: [:create , :update]
  before_action :pagination, only: [:index, :search]
  
  def show
    render json: @item_master
  end

  def index
    @item_masters  = ItemMaster.all
                               .desc
                               .page(@page_number)
                               .per(@page_size)
    render json: @item_masters, meta: {
                                  pagination: {
                                    total_objects: ItemMaster.count,
                                    per_page: @page_size || 10,
                                    total_pages: @item_masters.total_pages,
                                    current_page: @item_masters.current_page
                                  } 
                              }
  end

  def search
     @item_masters  = ItemMaster.all
                                .search_for(params[:q])
                                .desc
                                .page(@page_number || 1)
                                .per(@page_size || 10)
    render json: @item_masters, meta: {
                                  pagination: {
                                    total_objects: ItemMaster.count,
                                    per_page: @page_size || 10,
                                    total_pages: @item_masters.total_pages,
                                    current_page: @item_masters.current_page
                                  } 
                              }
  end  

  def create
     @item_master = ItemMaster.new(item_master_params)
    if @item_master.save
      render json: @item_master
    else
      render json: {
        message: @item_master.errors.full_messages
      }, status: 422
    end
  end

  def update
    @item_master.assign_attributes(item_master_params)
    if @item_master.save
      render json: @item_master
    else
      render json: {
        message: @item_master.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @item_master.destroy
    render_destroy_success
  end

  def clone
    @item_master_clone = @item_master.clone(item_master_params)
    if @item_master_clone.valid?
      render json: @item_master_clone
    else
      render json: {
        message: @item_master.errors.full_messages
      }, status: 422
    end
  end  

  private

  def item_master_params
    params.require(:item_master).permit(:name, :layout)
  end

  def set_item_master_by_params
    @item_master = ItemMaster.find_by_id params[:id]
    render_error_item_master_not_found if @item_master.nil?
  end

  def check_item_master_by_params
    render_layout_can_not_empty if Oj.load(item_master_params[:layout]).empty?
  end 

  def render_error_item_master_not_found
    render json: {
      message: 'Item master not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
      message: "Destroyed item master with id #{@item_master.id} successful"
    }
  end

  def render_layout_can_not_empty
     render json: {
      message: 'Layout can not empty'
    }, status: 404
  end

  def pagination
    if params[:page].present? && params[:size].present?
      @page_number = params[:page]
      @page_size = params[:size]
    end
  end
end
