class Track < ApplicationRecord
  include Pagination
  include TrackDetailsExporter

  validates :title, :file, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }
  validates :file, bitrate: { bits: [16, 24], sample_rate: 48_000 }
  validates :track_writers, presence: true
  validate :publishers_and_collaborators

  belongs_to :album

  has_one :user, through: :album

  has_one_attached :file

  has_many :notes, as: :notable, dependent: :destroy
  has_many :track_filters, dependent: :destroy
  has_many :filters, through: :track_filters
  has_many :track_publishers, dependent: :destroy
  has_many :publishers, through: :track_publishers
  has_many :track_writers, dependent: :destroy
  has_many :artists_collaborators, through: :track_writers

  accepts_nested_attributes_for :track_publishers, allow_destroy: true
  accepts_nested_attributes_for :track_writers, allow_destroy: true

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
    all.each_with_index.inject([]) do |zip_list, track_details, index|
      track = track_details.first
      file_name = zip_list.pluck(1).include?(track.filename) ? track.filename(index) : track.filename
      zip_list << [track.file, file_name]
    end
  end

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def track_writers=(attributes)
    existing_writers = track_writers.map { |writer| writer.attributes.slice('id', 'percentage', 'artists_collaborator_id').symbolize_keys }
    existing_writers.each do |writer|
      artist_attributes = attributes.find { |attr| attr[:artists_collaborator_id] == writer[:artists_collaborator_id] }
      if artist_attributes.present?
        writer[:percentage] = artist_attributes[:percentage]
      else
        writer[:_destroy] = true
      end
    end

    self.track_writers_attributes = existing_writers + attributes.reject { |attr| attr[:artists_collaborator_id].in?(existing_writers.pluck(:artists_collaborator_id)) }
  end

  def track_publishers=(attributes)
    existing_publishers = track_publishers.map { |publisher| publisher.attributes.slice('id', 'percentage', 'publisher_id').symbolize_keys }
    existing_publishers.each do |publisher|
      publisher_attributes = attributes.find { |attr| attr[:publisher_id] == publisher[:publisher_id] }
      if publisher_attributes.present?
        publisher[:percentage] = publisher_attributes[:percentage]
      else
        publisher[:_destroy] = true
      end
    end

    self.track_publishers_attributes = existing_publishers + attributes.reject { |attr| attr[:publisher_id].in?(existing_publishers.pluck(:publisher_id)) }
  end

  def publishers_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def artists_collaborator_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def publishers_and_collaborators
    publishers.each do |publisher|
      errors.add('publishers', "#{publisher.name} not belongs to this artist") if user.publishers.exclude?(publisher)
    end

    artists_collaborators.each do |collaborator|
      errors.add('artists_collaborators', "##{collaborator.collaborator_email} not belongs to this artist") if user.collaborators_details.exclude?(collaborator)
      errors.add('artists_collaborators', "##{collaborator.collaborator_email} not accepted invitation") unless collaborator.accepted?
    end

    if track_publishers.present? && track_publishers.map(&:percentage).sum != 100
      errors.add('track_publishers', 'percentage sum is not 100')
    end

    if track_writers.present? && track_writers.map(&:percentage).sum != 100
      errors.add('track_writers', 'percentage sum is not 100')
    end
  end
end
