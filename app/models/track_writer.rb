class TrackWriter < ApplicationRecord
  belongs_to :artists_collaborator
  belongs_to :track

  has_one :collaborator, through: :artists_collaborator

  validates_presence_of :track, :artists_collaborator
  validates_uniqueness_of :artists_collaborator_id, scope: [:track]

  def collaborator_email
    collaborator.email
  end
end
