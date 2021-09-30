class ConsumerPlaylist < ApplicationRecord
  belongs_to :consumer
  belongs_to :folder, optional: true
  has_many :playlist_tracks, as: :listable
  has_many :tracks, through: :playlist_tracks, dependent: :destroy

  has_one_attached :playlist_image
  has_one_attached :banner_image

  includes :tracks, file_attachment: :blob

  validates :playlist_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }

  accepts_nested_attributes_for :playlist_tracks, allow_destroy: true
end
