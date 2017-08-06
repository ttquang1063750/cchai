class Api::V1::Admin::LocalVariableSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :variable_type
end
