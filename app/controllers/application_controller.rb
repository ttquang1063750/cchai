require "csv"
class ApplicationController < ActionController::API  
  include DeviseTokenAuth::Concerns::SetUserByToken
  serialization_scope :view_context
end
