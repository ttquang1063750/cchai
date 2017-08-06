class Api::V1::Admin::BatchProcessSerializer < ActiveModel::Serializer
  attributes :id, :name, :operation, :repeat_time, :enable, :executed_at, :batch_process_type
  belongs_to :project
end
