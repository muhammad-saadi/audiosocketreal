class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :track_publishers
  has_many :tracks, through: :track_publishers, dependent: :restrict_with_exception

  validates :name, :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :ordered_by_pro, -> { order(Arel.sql("(case when  pro ILIKE 'us%' then 1 else 0 end) DESC, pro")) }

  before_save :reset_ipi
end
