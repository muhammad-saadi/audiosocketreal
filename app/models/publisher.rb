class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :restrict_with_exception

  validates :name, :pro, presence: true
  validates :ipi, numericality: true, length: { is: 9 }

  scope :ordered, -> { order(created_at: :desc) }
end
