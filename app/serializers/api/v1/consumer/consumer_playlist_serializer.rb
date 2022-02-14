class Api::V1::Consumer::ConsumerPlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :folder_id, :playlist_image, :banner_image

  has_many :playlist_tracks, serializer: Api::V1::Consumer::PlaylistTrackSerializer
  has_many :tracks, serializer: Api::V1::Consumer::TrackSerializer
  has_many :sfxes, serializer: Api::V1::Consumer::SfxSerializer

  def playlist_image
    object.playlist_image_url
  end

  def banner_image
    object.banner_image_url
  end
end
