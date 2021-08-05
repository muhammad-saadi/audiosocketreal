class Track < ApplicationRecord
  include Pagination
  include TrackDetailsExporter

  validates :title, :file, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }
  validates :file, bitrate: { bits: [16, 24], sample_rate: 48_000 }

  belongs_to :album
  belongs_to :publisher, optional: true
  belongs_to :artists_collaborator

  has_one_attached :file

  has_many :notes, as: :notable, dependent: :destroy
  has_many :track_filters, dependent: :destroy
  has_many :filters, through: :track_filters

  accepts_nested_attributes_for :track_filters

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES

  def filename(index = '')
    title + index + File.extname(file.filename.to_s)
  end

  def self.to_zip
    track_files = all.map do |track|
      next unless track.file.attached?

      [track.file, track.filename]
    end.compact

    track_files.each_with_index.inject([]) do |zip_list, track_file, index|
      zip_list << [track_file.first.first, (zip_list.pluck(1).include?(track_file.first.second) ? track_file.first.first.record.filename("(#{track_file.second})") : track_file.first.second)]
    end
  end
end
