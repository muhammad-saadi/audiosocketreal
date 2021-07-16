class Track < ApplicationRecord
  include Pagination

  validates :title, :file, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff audio/mpeg] }

  belongs_to :album
  belongs_to :publisher, optional: true
  belongs_to :artists_collaborator, optional: true

  has_one_attached :file

  has_many :notes, as: :notable, dependent: :destroy

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
end
