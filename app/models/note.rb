class Note < ApplicationRecord
  belongs_to :user
  belongs_to :notable, polymorphic: true

  has_many_attached :files

  scope :by_notable, -> (type, id){ where(notable_type: type, notable_id: id) }

  STATUSES = {
    pending: 'pending',
    completed: 'completed'
  }.freeze

  enum status: STATUSES
end
