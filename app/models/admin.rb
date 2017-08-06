class Admin < ActiveRecord::Base
  # Include default devise modules.
  enum role: %i(system viewer builder)

  devise :database_authenticatable, :rememberable,
         :trackable, :validatable
  #:confirmable, :omniauthable, :registerable, :recoverable
  include DeviseTokenAuth::Concerns::User
end
