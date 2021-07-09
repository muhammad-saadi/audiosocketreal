class Publisher < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :restrict_with_exception

  validates :name, :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { is: 9 }, allow_blank: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :ordered_by_pro, -> { order(Arel.sql("(case when  pro ILIKE 'us%' then 1 else 0 end) DESC, pro")) }

  before_save :reset_ipi

  private

  def reset_ipi
    self.ipi = nil if pro == 'NS'
  end
end
