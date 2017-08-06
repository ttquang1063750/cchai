class Api::V1::User::DatasourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project_by_params

  def get_query
    @rows = Row.query(get_query_params).distinct
    render json: @rows
  end

  def create_query
    @row = Row.create_record create_query_params
  end

  private

  def get_query_params
    params.permit(:table_id, cells: [:column_id, :value])
  end

  def create_query_params
    params.permit(:table_id, row_data: [:column_id, :value])
  end

  def set_project_by_params
    @project = Project.find_by_id(params[:project_id])
    render_error_project_not_found if @project.nil?
  end

  def render_error_roles_params_missing
    render json: {
      message: 'Missing roles params'
    }, status: 400
  end

end
