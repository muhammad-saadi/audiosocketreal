class PublisherUser < ApplicationRecord
  belongs_to :user
  belongs_to :publisher

  validates :user_id, uniqueness: { scope: :publisher_id, message: "already present!" }
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true
end
