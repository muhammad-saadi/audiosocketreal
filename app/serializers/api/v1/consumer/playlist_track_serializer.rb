class Api::V1::Consumer::PlaylistTrackSerializer < ActiveModel::Serializer
  attributes :id, :note, :order, :track

  def track
    Api::V1::Consumer::TrackSerializer.new(object.track)
  end
end
