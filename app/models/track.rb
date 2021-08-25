class Track < ApplicationRecord
  include Pagination
  include TrackDetailsExporter

  validates :title, :file, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }
  validates :file, bitrate: { bits: [16, 24], sample_rate: 48_000 }
  validates :artists_collaborators, presence: true
  before_save :publishers_and_collaborators

  belongs_to :album

  has_one_attached :file

  has_many :notes, as: :notable, dependent: :destroy
  has_many :track_filters, dependent: :destroy
  has_many :filters, through: :track_filters
  has_many :track_publishers
  has_many :publishers, through: :track_publishers
  has_many :track_writers
  has_many :artists_collaborators, through: :track_writers


  accepts_nested_attributes_for :track_filters

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES

  def filename(index = '')
    name = file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
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

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def publishers_and_collaborators
    publishers.each do |publisher|
      if album.user.publishers.exclude?(publisher)
        errors.add('publishers', "#{publisher.id} not belongs to this artist")
        publishers.delete(publisher)
      end
    end

    artists_collaborators.each do |collaborator|
      if album.user.collaborators_details.exclude?(collaborator)
        errors.add('artists_collaborators', "##{collaborator.id} not belongs to this artist")
        artists_collaborators.delete(collaborator)
      end

      unless collaborator.accepted?
        errors.add('artists_collaborators', "##{collaborator.id} not accepted invitation")
        artists_collaborators.delete(collaborator)
      end
    end
  end
end
