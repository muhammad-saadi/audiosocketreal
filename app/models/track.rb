require 'streamio-ffmpeg'

class Track < ApplicationRecord
  include Pagination
  include TrackDetailsExporter
  include AimsCallbacks
  include Favoritable
  include SoundTrack

  validates :title, presence: true
  validates :track_writers, presence: true, unless: :pending?
  validate :publishers_validation, unless: :pending?
  validate :artists_collaborators_validation, unless: :pending?
  validate :writers_percentage_validation, unless: :pending?
  validate :publishers_percentage_validation, unless: :pending?
  validate :any_audio_file_present?

  belongs_to :album
  belongs_to :parent_track, class_name: 'Track', optional: true

  after_save :convert_to_mp3_audio
  before_save :set_publish_date

  has_one :user, through: :album

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

  accepts_nested_attributes_for :track_publishers, allow_destroy: true
  accepts_nested_attributes_for :track_writers, allow_destroy: true

  STATUSES = {
    pending: 'pending',
    unclassified: 'unclassified',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES

  TRACK_EAGER_LOAD_COLS = [:alternate_versions, { filters: [:parent_filter, :tracks, sub_filters: [:tracks, sub_filters: [:tracks, :sub_filters]]], wav_file_attachment: :blob, aiff_file_attachment: :blob, mp3_file_attachment: :blob }].freeze

  scope :order_by, ->(attr, direction) { order("#{attr} #{direction}") }

  ransacker :char_id do
    Arel.sql("to_char(\"tracks\".\"id\", '99999')")
  end

  def filename(index = '')
    name = mp3_file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end

  def self.search(query, query_type, filters, order_by_attr, ids, direction = 'ASC')
    scope = self.all
    scope = scope.with_ids(ids) if ids.present?
    scope = scope.with_ids(aims_search_results(query)) if query_type == 'aims_search' && query.present?
    scope = scope.filter_search(filters) if filters.present?
    scope = scope.db_search(query) if query_type == 'local_search' && query.present?
    scope = scope.includes(TRACK_EAGER_LOAD_COLS)
    scope = scope.order_by(order_by_attr, direction)

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

  def set_publish_date
    return unless status_changed?
    return unless approved?

    self.publish_date = DateTime.now
  end

  def formatted_publish_date
    publish_date&.localtime&.strftime('%B %d, %Y %R')
  end

  def any_audio_file_present?
    unless FILE_TYPES.any? { |field| self.send(field).present? }
      FILE_TYPES.each do |field|
        errors.add(field, 'At least one track must be uploaded.')
      end
    end
  end

  def convert_to_mp3_audio
    return if attachment_changes['mp3_file'].present? || mp3_file.present?

    if attachment_changes.present?
      file = self.attachment_changes.first[0]
      file_path = self.attachment_changes["#{file}"].attachable.path
      mp3_file_path = file_path.downcase.gsub('.aiff', ".mp3").gsub('.wav', '.mp3')
    else
      file = aiff_file.present? ? "aiff_file" : "wav_file"
      file_key = send(file).key
      file_path = ActiveStorage::Blob.service.path_for(file_key)
      mp3_file_path = "#{file_path}.mp3"
    end

    mp3_file_name = send(file).blob.filename.to_s.downcase.gsub('.aiff', ".mp3").gsub('.wav', '.mp3')
    system("ffmpeg -i #{file_path} -f mp3  #{mp3_file_path}")
    self.mp3_file.attach(io: File.open(mp3_file_path), filename: "#{mp3_file_name}", content_type: 'audio/mpeg')
  end
end
