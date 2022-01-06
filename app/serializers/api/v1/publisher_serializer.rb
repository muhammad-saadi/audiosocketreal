class Api::V1::PublisherSerializer < BaseSerializer
  attributes :id, :name

  has_many :publisher_users
end
