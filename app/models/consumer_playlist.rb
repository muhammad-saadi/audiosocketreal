class ConsumerPlaylist < ApplicationRecord
  include FavoriteFollowable
  include Mediable

  belongs_to :consumer
  belongs_to :folder, optional: true

  has_one_attached :playlist_image
  has_one_attached :banner_image

  validates :name, presence: true
  validates :playlist_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }

  validate :folder_validation

  PLAYLIST_EAGER_LOAD_COLS = [{ banner_image_attachment: :blob, playlist_image_attachment: :blob,
                                tracks: Track::TRACK_EAGER_LOAD_COLS,
                                sfxes: Sfx::SFX_EAGER_LOAD_COLS }, :playlist_tracks].freeze

  accepts_nested_attributes_for :playlist_tracks, allow_destroy: true

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
end
