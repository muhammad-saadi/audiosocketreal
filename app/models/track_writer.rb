class TrackWriter < ApplicationRecord
  belongs_to :artists_collaborator
  belongs_to :track

  validates_uniqueness_of :artists_collaborator_id, scope: [:track]
end
