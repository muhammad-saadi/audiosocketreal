class ConsumerPlaylist < ApplicationRecord
  belongs_to :consumer
  belongs_to :folder, optional: true
  has_many :playlist_tracks, as: :listable
  has_many :tracks, through: :playlist_tracks, dependent: :destroy

  has_one_attached :playlist_image
  has_one_attached :banner_image

  validates :playlist_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }
  validate :set_folder, on: [:create, :update]

  accepts_nested_attributes_for :playlist_tracks, allow_destroy: true

  def self.eagerload_columns
    { banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob] }
  end

  def set_folder
    consumer.folders.find(folder_id) if folder_id.present?
  end

  def playlist_image_url
    playlist_image.presence && UrlHelpers.rails_blob_url(playlist_image)
  end

  def banner_image_url
    banner_image.presence && UrlHelpers.rails_blob_url(banner_image)
  end
end
