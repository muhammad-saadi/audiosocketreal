class Api::V1::Consumer::ConsumerPlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :folder_id, :playlist_image, :banner_image, :playlist_tracks

  has_many :playlist_tracks, serializer: Api::V1::Consumer::PlaylistTrackSerializer

  def playlist_image
    object.playlist_image_url
  end

  def banner_image
    object.banner_image_url
  end
end
