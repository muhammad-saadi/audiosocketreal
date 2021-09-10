class Api::V1::Consumer::ConsumerProfileSerializer < ActiveModel::Serializer
  attributes :id, :phone, :organization, :address, :city, :country, :postal_code, :youtube_url, :white_listing_enabled
end
