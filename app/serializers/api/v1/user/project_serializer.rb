class Api::V1::User::ProjectSerializer < ActiveModel::Serializer
  attributes :id

  has_many :pages do |serializer|
    serializer.get_first_page_layout
  end
  
  def get_first_page_layout
    object.pages.first
  end

  def get_session_variables
    object.session_variables
  end

end
