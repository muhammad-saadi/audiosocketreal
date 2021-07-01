class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :restrict_with_exception

  validates :name, :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { is: 9 }, allow_blank: true

  scope :ordered, -> { order(created_at: :desc) }
end
