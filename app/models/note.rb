class Note < ApplicationRecord
  belongs_to :user
  belongs_to :notable, polymorphic: true

  has_many_attached :files

  STATUSES = {
    pending: 'pending',
    completed: 'completed'
  }.freeze

  enum status: STATUSES
end
