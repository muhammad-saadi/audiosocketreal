class Api::V1::UserSerializer < BaseSerializer
  attributes :id, :email, :first_name, :last_name
end
