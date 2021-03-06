class Api::V1::AlbumSerializer < BaseSerializer
  attributes :id, :name, :release_date, :artwork

  has_many :tracks, serializer: Api::V1::TrackSerializer

  def artwork
    object.artwork.presence && UrlHelpers.rails_blob_url(object.artwork)
  end
end
