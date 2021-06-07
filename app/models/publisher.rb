class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :restrict_with_exception

  validates :name, :pro, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
