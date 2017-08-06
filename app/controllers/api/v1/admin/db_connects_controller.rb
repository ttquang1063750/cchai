class Api::V1::Admin::DbConnectsController < Api::V1::AdminController
  before_action :set_project_by_params, only: [:show, :index, :create, :update, :destroy]
  before_action :set_db_connect_by_params, only: [:update, :destroy]

  def show
    @db_connect = @project.db_connect
    render json: @db_connect
  end

  def index
    @db_connect = @project.db_connect
    render json: @db_connect
  end

  def all 
    @db_connects = DbConnect.all
                            .desc
                            .page(@page_number || 1)
                            .per(@page_size || 10)
    render json: @db_connects, meta: { 
                                pagination: { 
                                  total_objects: DbConnect.count,
                                  per_page: @db_connects || 10,
                                  total_pages: @db_connects.total_pages,
                                  current_page: @db_connects.current_page
                                } 
                              }
  end   

  def create
    @db_connect_exist = DbConnect.find_by(
                                          host: db_connect_params[:host], database: db_connect_params[:database],
                                          port: db_connect_params[:port], username: db_connect_params[:username]
                                        )
    if @db_connect_exist.nil?
      @db_connect = @project.create_db_connect(db_connect_params)
      if @db_connect.save
        create_schema(@db_connect)
        Shard_Connect.connect_to_shard
        begin
          sql_execute(@db_connect.database)
          create_table_default(@db_connect, @project.id)  # Create table_count 
          render json: @db_connect
        rescue Exception => exc
          @db_connect.destroy
          render_error_db_not_connect(exc.message)
        end
      else
        render json: @db_connect, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
      end
    else
      render_db_exist_connect
    end
  end

  def update
    @db_connect.assign_attributes(db_connect_params)
    if @db_connect.save
      render json: @db_connect
    else
      render json: @db_connect, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end
  
  def destroy
    @db_connect.destroy
    render_destroy_success
  end

  private

  def create_schema(connection)
    query = "CREATE SCHEMA IF NOT EXISTS `#{connection.database}` DEFAULT CHARACTER SET utf8"
    ActiveRecord::Base.establish_connection(
      adapter:  connection.adapter,
      host:     connection.host,
      username: connection.username,
      password: connection.password
    ).connection.execute query
    ActiveRecord::Base.establish_connection(Rails.env.to_sym).connection
  end

  def sql_execute(shard_name)
    path = Rails.root.join('db/init.sql').to_s
    # Split divides str into substrings based on a delimiter, returning an array of these substrings
    sql = File.read(path).split(/;/)
    sql = Oj.load(sql.to_s % { :schema => shard_name })
    sql.each { |query| ActiveRecord::Base.using(shard_name.to_sym).connection.execute query if query.present? }
  end

  def create_table_default(connection, project_id)
    Octopus.using(connection.database.to_sym) do
      table_default = Table.find_by_name('table_count')
      if table_default.present?
        column_name = Column.find_by(name: 'table_name', table_id: table_default.id)
        column_value = Column.find_by(name: 'count_value', table_id: table_default.id)
      else
        table_default = Table.create(name: 'table_count', project_id: project_id) 
      end  
      if column_name.nil? && column_value.nil?
        Column.create(name: 'table_name', content_type: 0, table_id: table_default.id) 
        Column.create(name: 'count_value', content_type: 1, table_id: table_default.id) 
      end
    end
  end  

  def db_connect_params
    params.require(:db_connect)
          .permit(:host, :adapter, :database, :username, :password, :port)
  end

  def set_db_connect_by_params
    @db_connect = DbConnect.find_by(id: params[:id], project_id: params[:project_id])
    render_error_db_not_found if @db_connect.nil?
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def render_error_db_not_found
    render json: {
        message: 'Shard not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
        message: 'Project not found'
    }, status: 404
  end

  def render_destroy_success
    render json: {
        message: 'Destroy successful'
    }
  end

  def render_error_db_not_connect(message)
    render json: {
        message: message
    }, status: 404
  end

  def render_db_exist_connect
    render json: {
        message: 'Database was exist connected'
    }, status: 404
  end  
end
