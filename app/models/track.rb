class Track < ApplicationRecord
  validates :title, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }

  belongs_to :album
  belongs_to :publisher, optional: true
  belongs_to :collaborator, class_name: 'User', optional: true

  has_one_attached :file

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES

  def self.pagination(params)
    return all if params[:pagination] == 'false'

    page(params[:page].presence || 1).per(params[:per_page].presence || PER_PAGE)
  end
end
