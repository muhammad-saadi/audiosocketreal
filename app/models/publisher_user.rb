class PublisherUser < ApplicationRecord
  belongs_to :publisher
  belongs_to :user

  validates :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true
  validates :publisher_id, uniqueness: { scope: :user_id }

  scope :ordered_by_pro, -> { order(Arel.sql("(case when pro ILIKE 'us%' then 1 else 0 end) DESC, pro")) }

  before_save :reset_ipi
end
