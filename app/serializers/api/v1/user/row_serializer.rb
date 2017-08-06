class Api::V1::User::RowSerializer < ActiveModel::Serializer
  attributes :id, :unique_id
  # def content
  #   raw = Raw.find_by(row_id: object.id).data
  #   data = Oj.load(raw).merge({row_id: raw.row_id, table_id: raw.table_id})
  # end
end
