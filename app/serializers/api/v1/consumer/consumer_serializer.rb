class Api::V1::Consumer::ConsumerSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :email, :content_type

  has_one :consumer_profile
end
