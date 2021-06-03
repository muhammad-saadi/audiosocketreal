class Api::V1::ContactInformationSerializer < ActiveModel::Serializer
  attributes :name, :phone, :street, :postal_code, :city, :state, :country
end
