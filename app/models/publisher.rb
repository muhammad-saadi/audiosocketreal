class Publisher < ApplicationRecord
  include Pagination

  has_many :publisher_users, dependent: :destroy
  has_many :users, through: :publisher_users
  has_many :track_publishers
  has_many :tracks, through: :track_publishers, dependent: :restrict_with_exception

  validates :name, :pro, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :publisher_users
end
