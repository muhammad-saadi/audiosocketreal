class PlaylistTrack < ApplicationRecord
  belongs_to :track
  belongs_to :listable, polymorphic: true
  validates_uniqueness_of :track_id, scope: [:listable_id]
end
