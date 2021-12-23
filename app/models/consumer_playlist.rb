class ConsumerPlaylist < ApplicationRecord
  include FavoriteFollowable

  attr_accessor :current_consumer

  belongs_to :consumer
  belongs_to :folder, optional: true

  has_many :playlist_tracks, as: :listable
  has_many :tracks, through: :playlist_tracks, dependent: :destroy

  has_one_attached :playlist_image
  has_one_attached :banner_image

  validates :name, presence: true
  validates :playlist_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }

  validate :folder_validation
  validate :follow_playlist_validation

  accepts_nested_attributes_for :playlist_tracks, allow_destroy: true

  def self.eagerload_columns
    { banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob] }
  end

  def folder_validation
    return if folder_id.blank?

    errors.add(:folder, 'is invalid') if consumer_id != folder&.consumer_id
  end

  def playlist_image_url
    playlist_image.presence && UrlHelpers.rails_blob_url(playlist_image)
  end

  def banner_image_url
    banner_image.presence && UrlHelpers.rails_blob_url(banner_image)
  end

  def follow_playlist_validation
    errors.add(:playlist, 'Consumer can not follow their own playlist.') if self.consumer == current_consumer
  end
end
