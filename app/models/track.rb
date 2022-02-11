require 'streamio-ffmpeg'

class Track < ApplicationRecord
  include Pagination
  include TrackDetailsExporter
  include AimsCallbacks
  include Favoritable

  validates :title, presence: true
  validates :file, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }
  validates :file, bitrate: { bits: [16, 24], sample_rate: 48_000 }
  validates :track_writers, presence: true, unless: :pending?
  validate :publishers_validation, unless: :pending?
  validate :artists_collaborators_validation, unless: :pending?
  validate :writers_percentage_validation, unless: :pending?
  validate :publishers_percentage_validation, unless: :pending?

  belongs_to :album
  belongs_to :parent_track, class_name: 'Track', optional: true

  after_save :set_duration
  before_save :set_publish_date

  has_one :user, through: :album

  has_one_attached :file

  has_many :notes, as: :notable, dependent: :destroy
  has_many :media_filters, as: :filterable, dependent: :destroy
  has_many :filters, through: :media_filters
  has_many :track_publishers, dependent: :destroy
  has_many :publishers, through: :track_publishers
  has_many :track_writers, dependent: :destroy
  has_many :artists_collaborators, through: :track_writers
  has_many :alternate_versions, foreign_key: 'parent_track_id', class_name: 'Track'
  has_many :playlist_tracks, dependent: :destroy
  has_many :consumer_playlists, through: :playlist_tracks, source: :listable, source_type: 'ConsumerPlaylist', dependent: :destroy
  has_many :curated_playlists, through: :playlist_tracks, source: :listable, source_type: 'CuratedPlaylist', dependent: :destroy
  has_many :license_tracks, as: :mediable, dependent: :destroy
  has_many :licenses, through: :license_tracks
  has_many :collection_tracks, dependent: :destroy
  has_many :collections, through: :collection_tracks

  accepts_nested_attributes_for :track_publishers, allow_destroy: true
  accepts_nested_attributes_for :track_writers, allow_destroy: true

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
  TEMP_PRICE = 50

  scope :order_by, ->(attr, direction) { order("#{attr} #{direction}") }

  ransacker :char_id do
    Arel.sql("to_char(\"tracks\".\"id\", '99999')")
  end

  TRACK_EAGER_LOAD_COLS = [:alternate_versions, { filters: [:parent_filter, :tracks, sub_filters: [:tracks, sub_filters: [:tracks, :sub_filters]]], file_attachment: :blob }].freeze

  scope :order_by, ->(attr, direction) { order("#{attr} #{direction}") }

  ransacker :char_id do
    Arel.sql("to_char(\"tracks\".\"id\", '99999')")
  end

  def filename(index = '')
    name = file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end

  def self.search(ids, direction = 'ASC', attrs = {})
    scope = self
    scope = scope.with_ids(ids) if ids.present?
    scope = scope.with_ids(aims_search_results(attrs[:query])) if attrs[:query_type] == 'aims_search' && attrs[:query].present?
    scope = scope.filter_search(attrs[:filters]) if attrs[:filters].present?
    scope = scope.db_search(attrs[:query]) if attrs[:query_type] == 'local_search' && attrs[:query].present?
    scope = scope.where(explicit: attrs[:explicit]) if attrs[:explicit].present?
    scope = scope.includes(TRACK_EAGER_LOAD_COLS)
    scope = scope.order_by(attrs[:order_by_attr], direction)

    scope
  end

  def self.aims_search_results(url)
    AimsApiService.search_by('link', url, 'url')
  end

  def self.with_ids(ids)
    self.ransack('id_in': ids).result(distinct: true)
  end

  def self.db_search(query)
    query_words = query.split(' ')
    query_words << query
    query_array = query_words.flatten.uniq
    query_array = query_array.map{ |obj| "%#{obj}%" }

    self.ransack("char_id_or_title_or_album_name_or_user_first_name_or_user_last_name_or_filters_name_matches_any": query_array).result(distinct: true)
  end

  def self.filter_search(filters)
    self.ransack("filters_name_matches_any": filters).result(distinct: true)
  end

  def self.to_zip
    all.each_with_index.inject([]) do |zip_list, (track, index)|
      next zip_list unless track.file.attached?

      file_name = zip_list.pluck(1).include?(track.filename) ? track.filename(" (#{index})") : track.filename
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
      artist_attributes = attributes.find { |attr| attr[:artists_collaborator_id].to_i == writer[:artists_collaborator_id] }
      if artist_attributes.present?
        writer[:percentage] = artist_attributes[:percentage]
      else
        writer[:_destroy] = true
      end
    end

    self.track_writers_attributes = existing_writers + attributes.reject { |attr| attr[:artists_collaborator_id].to_i.in?(existing_writers.pluck(:artists_collaborator_id)) }
  end

  def track_publishers=(attributes)
    existing_publishers = track_publishers.map { |publisher| publisher.attributes.slice('id', 'percentage', 'publisher_id').symbolize_keys }
    existing_publishers.each do |publisher|
      publisher_attributes = attributes.find { |attr| attr[:publisher_id].to_i == publisher[:publisher_id] }
      if publisher_attributes.present?
        publisher[:percentage] = publisher_attributes[:percentage]
      else
        publisher[:_destroy] = true
      end
    end

    self.track_publishers_attributes = existing_publishers + attributes.reject { |attr| attr[:publisher_id].to_i.in?(existing_publishers.pluck(:publisher_id)) }
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

  def publishers_validation
    track_publishers.each do |publisher|
      errors.add('publishers', "#{publisher.publisher_name} not belongs to this artist") if user.publisher_ids.exclude?(publisher.publisher_id)
    end
  end

  def artists_collaborators_validation
    track_writers.each do |collaborator|
      errors.add('artists_collaborators', "#{collaborator.collaborator_email} not belongs to this artist") if user.collaborators_detail_ids.exclude?(collaborator.artists_collaborator_id)
      errors.add('artists_collaborators', "#{collaborator.collaborator_email} not accepted invitation") unless collaborator.artists_collaborator&.accepted?
    end
  end

  def publishers_percentage_validation
    current_publishers = track_publishers.reject(&:marked_for_destruction?)
    return unless current_publishers.present? && current_publishers.map(&:percentage).compact.sum != 100

    errors.add('track_publishers', 'percentage sum is not 100')
  end

  def writers_percentage_validation
    current_writers = track_writers.reject(&:marked_for_destruction?)
    return unless current_writers.present? && current_writers.map(&:percentage).compact.sum != 100

    errors.add('track_writers', 'percentage sum is not 100')
  end

  def set_duration
    return if self.attachment_changes.empty?

    filepath = self.attachment_changes['file'].attachable.path
    self.update_columns(duration: FFMPEG::Movie.new(filepath).duration&.round(2))
  end

  def set_publish_date
    return unless status_changed?
    return unless approved?

    self.publish_date = DateTime.now
  end

  def formatted_publish_date
    publish_date&.localtime&.strftime('%B %d, %Y %R')
  end

  def filter_count
    self.filters.size
  end
end
