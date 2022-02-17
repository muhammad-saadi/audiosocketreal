class Api::V1::Consumer::CuratedPlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :order, :keywords, :playlist_image, :banner_image, :playlist_tracks

  has_many :playlist_tracks, serializer: Api::V1::Consumer::PlaylistTrackSerializer

  def playlist_image
    object.playlist_image.presence && UrlHelpers.rails_blob_url(object.playlist_image)
  end

  def banner_image
    object.banner_image.presence && UrlHelpers.rails_blob_url(object.banner_image)
  end
end
