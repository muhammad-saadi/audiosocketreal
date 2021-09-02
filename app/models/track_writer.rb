class TrackWriter < ApplicationRecord
  belongs_to :artists_collaborator
  belongs_to :track

  has_one :collaborator, through: :artists_collaborator

  validates_presence_of :track, :artists_collaborator, :percentage
  validates_uniqueness_of :artists_collaborator_id, scope: [:track]
  validates :percentage, numericality: { greater_than_or_equal_to: 0 }

  def collaborator_email
    collaborator&.email
  end

  def collaborator_name
    collaborator&.full_name
  end
end
