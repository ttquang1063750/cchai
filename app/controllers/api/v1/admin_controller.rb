class Api::V1::AdminController < ApplicationController
  include CanCan::ControllerAdditions
  before_action :authenticate_admin!

  rescue_from CanCan::AccessDenied do |exception|
    render json: {
      message: "Not have permission"
    }, status: 403
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end
end