class Api::V1::Admin::ProjectsController < Api::V1::AdminController
  before_action :set_project_by_params, only: [:show, :update, :destroy, :users, :clone]
  before_action :pagination, only: [:index, :users, :search]
  before_action :project_params, only: [:create, :update, :clone]

  def show
    authorize! :write, @project
    render json: @project, include: 'role_types'
  end

  def index
    @projects = Project.includes(:role_types, :pages, :client, :db_connect)
                       .desc
                       .page(@page_number || 1)
                       .per(@page_size || 10)
    render json: @projects, meta: { 
                              pagination: { 
                                total_objects: Project.count,
                                per_page: @page_size || 10,
                                total_pages: @projects.total_pages,
                                current_page: @projects.current_page
                              } 
                            }
                          
  end

  def users
    @users = @project.users
                     .page(@page_number || 1)
                     .per(@page_size || 10)
                     .includes(:project)
    render json: @users,  meta: { 
                              pagination: { 
                                total_objects: @users.count,
                                per_page: @page_size || 10,
                                total_pages: @users.total_pages,
                                current_page: @users.current_page
                              } 
                          },
                          each_serializer: Api::V1::Admin::UserProjectSerializer,
                          project_id: @project.id
  end

  def search
    @projects = Project.all
                       .search_for(params[:q])
                       .desc
                       .page(@page_number || 1)
                       .per(@page_size || 10)
    render json: @projects, meta: { 
                              pagination: { 
                                total_objects: @projects.count,
                                per_page: @page_size || 10,
                                total_pages: @projects.total_pages,
                                current_page: @projects.current_page
                              } 
                            }
  end

  def create
    @project = Project.new(@project_params)
    authorize! :create, @project
    if @project.save
      role_types = []
      params_role_types_default.each { |e| role_types << (RoleType.new name: e, project_id: @project.id) } # Create role_types default
      role_types.each(&:save)
      Page.create name: 'SignIn', sluck: 'signin', layout: "{\"children\":[]}", project_id: @project.id # Create default page
      render json: @project
    else
      render json: {
        message: @project.errors.full_messages
      }, status: 422
    end
  end

  def update
    authorize! :update, @project
    @project.assign_attributes(@project_params)
    if @project.save
      render json: @project
    else
      render json: {
        message: @project.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    authorize! :destroy, @project
    @project.destroy
    render_destroy_success
  end

  def clone
    @project = @project.clone(@project_params, @db_connect)
    if @project[:project_dup].present?
      if @project[:project_dup].valid?
        render json: @project[:project_dup]
      else
        render json: {
          message: @project[:project_dup].errors.full_messages
        }, status: 422
      end
    else
      render json: {
        message: @project[:error]
      }, status: 404
    end
  end

  private

  def render_destroy_success
    render json: {
      message: "Destroyed project with id #{@project.id} successful"
    }
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

  def set_project_by_params
    @project = Project.find_by_id params[:id]
    render_error_project_not_found if @project.nil?
  end

  def project_params
    @project_params = params.require(:project)
                            .permit(:name, :short_name, :patitent_num, :period_start_date, :period_end_date, :client_id)
    @db_connect = params[:project][:db_connect].permit! if params[:project][:db_connect].present?
  end

  def pagination
    if params[:page].present? && params[:size].present?
      @page_number = params[:page]
      @page_size = params[:size]
    end  
  end

  def params_role_types_default
    RoleType::DEFAULT_ROLE_TYPES
  end
end
