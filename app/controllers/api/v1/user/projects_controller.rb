class Api::V1::User::ProjectsController < ApplicationController
  before_action :take_project_by_params, only: [:show]

  def show
    render json: {
      project: @project,
      page: @project.pages.first,
      session_variables: get_session_variables,
      local_variables: get_local_variables
    }
  end

  private

  def take_project_by_params
    @project = Project.friendly.find(params[:id])
    render_error_project_not_found if @project.nil?
  end
  def get_session_variables
    @project.session_variables.reduce({}) do |init, e|
      init.merge({ e.name.to_sym => { id: e.id, value: e.value, variable_type: e.variable_type } })
    end
  end

  def get_local_variables
    @project.pages.first.local_variables.reduce({}) do |init, e|
      init.merge({ e.name.to_sym => { id: e.id, value: e.value, variable_type: e.variable_type } })
    end
  end

  def render_error_project_not_found
    render json: {
      message: 'Project not found'
    }, status: 404
  end
end
