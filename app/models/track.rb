class Track < ApplicationRecord
  validates :title, presence: true

  belongs_to :album

  has_one_attached :file

  STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
end
