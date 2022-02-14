class Api::V1::Consumer::PlaylistTrackSerializer < ActiveModel::Serializer
  attributes :id, :note, :order, :mediable_type, :mediable_id
end
