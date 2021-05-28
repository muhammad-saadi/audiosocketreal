class Track < ApplicationRecord
  validates :title, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }

  belongs_to :album
  belongs_to :publisher, optional: true
  belongs_to :collaborator, class_name: 'User', optional: true

  has_one_attached :file

  STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
end
