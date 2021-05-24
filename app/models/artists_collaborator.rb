class ArtistsCollaborator < ApplicationRecord
  belongs_to :artist, class_name: "User", optional: true
  belongs_to :collaborator, class_name: "User", optional: true

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
end
