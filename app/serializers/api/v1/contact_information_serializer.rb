class Api::V1::ContactInformationSerializer < ActiveModel::Serializer
  attributes :name, :street, :postal_code, :city, :state, :country
end
