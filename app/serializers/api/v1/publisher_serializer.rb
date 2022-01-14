class Api::V1::PublisherSerializer < BaseSerializer
  attributes :id, :name, :default_publisher

  has_many :publisher_users
end
