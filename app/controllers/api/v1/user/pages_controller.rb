class Api::V1::User::PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_database_connect_by_params, only: [:show, :show_operation, :create_csv_export, :create_or_update, :delete]
  before_action :get_project_by_params, only: [:show, :create_or_update, :delete]
  before_action :get_page_by_params, only: [:show, :create_or_update, :delete]
  before_action :get_table_by_params, only: [:show]
  before_action :get_role_type_by_params, only: [:show, :create_or_update, :delete]
  before_action :get_operation_page_table_by_params, only: [:show_operation, :create_csv_export]
  before_action :check_sort_condition, :pagination, only: [:show_operation]
  before_action :get_data_send_email_by_params, only: [:send_email]
  
  def show
    render json: {
            data: {
              name: @page.name,
              sluck: @page.sluck,
              layout: @page.layout_filter_by_user(current_user).exec_filter,
              operations: {
                  init: @page.operations.init.as_json,
                  join: @page.operations.active.as_json,
                  log: @page.operations.log.as_json
              },
              tables: @tables_data, 
              local_variables: get_local_variables,
              session_variables: get_session_variables,
              user_email: current_user.email,
              role_types: @role_types,
              role_names: @role_names
            } 
          }
  end

  def show_operation
    case @operation.stage
    when 'log'
      order_by = { column: @sort_by_column, direction: @direction }
      store = Page.get_store_for_page_show(Store.new, @operation, @client_query_condition, @table, order_by, @database)
      array_data = store.db[@operation.name]
    else
      store = Page.get_store_for_page_show(Store.new, @operation, @client_query_condition, @table, nil, @database)  
      array_data = sort_table(store.db[@operation.name], @sort_by_column, @direction)
    end
    paginatable_array = Kaminari.paginate_array(array_data).page(@page_number || 1).per(@page_size || 10)
    if @is_array == 1
      render json: {
          operations: {
              @operation.name.to_sym => {
                  data: paginatable_array,
                  meta: {
                      pagination: {
                          per_page: @page_size || 10,
                          current_page: paginatable_array.current_page,
                          total_pages: paginatable_array.total_pages,
                          total_objects: array_data.count
                      }
                  }
              }
          }
      }
    else
      render json: {
          operations: {
            @operation.name.to_sym => {
                data: paginatable_array[0]
            }
          }
      }
    end
  end

  def display_csv_export
    arr = []
    Dir[File.join('public', 'uploads', 'csv_export', params[:project_id], '*.csv')].each do |file|
      first_split = file.split('/').last
      operation_id = first_split.split('.').first
      hash = { project_id: params[:project_id].to_i, url: file, operation_id: operation_id.to_i }
      arr << hash
    end
    render json: {
       data: arr
    }
  end

  def create_csv_export
    if @operation.background_mode == 1
      path = File.join('uploads', 'csv_export', @table.project_id.to_s)
      CsvExport.create name: @operation.name, data_location: File.join(path, @operation.id.to_s, '.csv'), stage: @operation.stage
      OperationOneTableJob.perform_later(@table, @operation, @client_query_condition, @headers, @database)
      render json: {
         operations: 'succeed',
         link: File.join(path, @operation.id.to_s, '.csv')
      }
    else
      store = Page.get_store_for_page_show(Store.new, @operation, @client_query_condition, @table, nil, @database)
      datas = sort_table(store.db[@operation.name], @sort_by_column, @direction)
      datas = [] << datas.first unless @is_array == 1
      new_datas = Page.change_value_csv(@table.columns, datas)
      csv_string= Page.to_csv(@headers, new_datas, @table, @operation)
      render json: {
         data: csv_string,
         name: @table.name
      }
    end
  end

  def create_or_update
    row = []
    create_or_update_params.each do |value|
      item = Row.extract_row_params_from_value(value, current_user.email, @role_names, @page_name)
      row.push(Row.create_or_update(item, @database))
    end
    render json: row
  end

  def delete
    row = []
    info = {}
    info[:email] = current_user.email
    info[:role_type] = @role_names.join(',')
    info[:page_name] = @page.name
    delete_params.each do |value|
      item = Row.extract_row_ids_from_value(value)
      Row.delete_row(item, @database, info)
    end
    render json: row
  end

  def send_email
    # exists = BatchProcess.find_by_name(@batch_process_params[:name])
    # if exists.nil?
    #   @batch_process = @project.batch_processes.new(@batch_process_params)
    # else
    #   @batch_process = BatchProcess.find_by(name: @batch_process_params[:name], project_id: @project.id)
    #   @batch_process.assign_attributes(@batch_process_params)
    # end    
    # if @batch_process.save
    #   render json: @batch_process
    # else
    #   render json: {
    #       message: @batch_process.errors.full_messages
    #   }, status: 422
    # end
    mail_options = Oj.load(@batch_process_params[:operation]).with_indifferent_access
    NotifierMailer.new_email(mail_options).deliver_now
  end

  private

  def get_database_connect_by_params
    @database = DbConnect.find_by(project_id: params[:project_id])
    @page_name = params[:id]
  end

  def get_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def get_page_by_params
    @page = @project.pages.find_by(sluck: params[:id])
    render_error_page_not_found if @page.nil?
  end

  def get_table_by_params
    @tables_data = []
    Table.using(@database.database.to_sym).where(project_id: params[:project_id]).each { |e| @tables_data << { id: e.id, name: e.name } }
  end  

  def get_role_type_by_params
    @role_types = []
    @role_names = []
    Role.where(user_id: current_user.id).map(&:role_type_id).each do |e|
      role_type = RoleType.find_by(id: e, project_id: @project.id)
      @role_names << role_type.name && @role_types << e unless role_type.nil?
    end  
  end

  def get_operation_page_table_by_params
    @client_query_condition = params[:operation][:query]
    @headers = params[:operation][:header]
    @is_array = params[:operation][:is_array]
    @operation = Operation.find_by_id(params[:operation][:id])
    @page = Page.find_by_id(@operation.page_id)
    @table = Table.using(@database.database.to_sym).find_by(name: @operation.ds_name, project_id: @page.project_id)
  end

  def check_sort_condition
    if params[:direction].present? && params[:sort_by_column].present?
      @direction = sort_direction
      @sort_by_column = params[:sort_by_column]
    else
      @direction = 'asc'
      @operation.stage == 'log' ? @sort_by_column = 'id' : @sort_by_column = 'row_id'
    end
  end

  def pagination
    if params[:operation][:page].present? && params[:operation][:size].present?
      @page_number = params[:operation][:page]
      @page_size = params[:operation][:size].to_i
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def get_data_send_email_by_params
    # @project = Project.find_by_id(params[:projectId])
    # params[:batch_process][:executed_at] =  Time.parse(params[:batch_process][:executed_at]).utc.iso8601 
    # @batch_process_params = params.require(:batch_process).permit(:name, :enable, :repeat_time, :operation, :batch_process_type, :executed_at)
    @batch_process_params = params.require(:batch_process).permit(:operation)
  end  

  def sort_table(array, sort_by_column, direction)
    case direction
    when 'desc'
        array = array.sort_by { |v| check_column_type(v["#{sort_by_column}"]) }.reverse!
    when 'asc'
        array = array.sort_by { |v| check_column_type(v["#{sort_by_column}"]) }
    else
      array = array.sort_by { |v| check_column_type(v["#{sort_by_column}"]) }
    end
    array
  end

  def check_column_type(column)
    column = column.downcase if column.class == String
    column = column.to_s if column.class.nil?
    column
  end

  def create_or_update_params
    params.permit!.to_h[:rows]
  end

  def delete_params
    params[:rows] = Oj.load(params[:rows])
    params.permit!.to_h[:rows]
  end

  def get_local_variables
    @page.local_variables.reduce({}) do |init, e|
      init.merge({ e.name.to_sym => { id: e.id, value: e.value, variable_type: e.variable_type } })
    end
  end

  def get_session_variables
    @project.session_variables.reduce({}) do |init, e|
      init.merge({ e.name.to_sym => { id: e.id, value: e.value, variable_type: e.variable_type } })
    end
  end

  def render_error_page_not_found
    render json: {
      message: 'Page not found'
    }, status: 404
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end

end


