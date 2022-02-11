class Collection < ApplicationRecord
  has_many :collection_tracks, dependent: :destroy
  has_many :tracks, through: :collection_tracks
end
