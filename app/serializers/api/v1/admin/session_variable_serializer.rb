class Api::V1::Admin::SessionVariableSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :variable_type
end
