class Api::V1::Consumer::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name
end
