class Api::V1::User::LogChangementSerializer < ActiveModel::Serializer
  attributes :id,:user_id, :project_id ,:page_id, :column_id,:column_name,:bf_item,:af_item,:created_at,:page_name,:project_name
end
