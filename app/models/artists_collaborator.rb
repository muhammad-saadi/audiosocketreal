class ArtistsCollaborator < ApplicationRecord
  belongs_to :artist, class_name: "User", optional: true
  belongs_to :collaborator, class_name: "User", optional: true

  validate :self_collaborator_invite

  STATUSES = {
    pending: 'pending',
    accepted: 'accepted',
    rejected: 'rejected'
  }.freeze

  ACCESSES = {
    read: 'read',
    write: 'write'
  }.freeze

  enum status: STATUSES
  enum access: ACCESSES

  def encoded_id
    JsonWebToken.encode({ id: id })
  end

  private

  def self_collaborator_invite
    errors.add(:base, 'Could not invite yourself as collaborator') if artist_id == collaborator_id
  end
end
