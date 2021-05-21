class ArtistsCollaborator < ApplicationRecord
  belongs_to :artist, class_name: "User", optional: true
  belongs_to :collaborator, class_name: "User", optional: true

  STATUSES = {
    pending: 'pending',
    accepted: 'accepted',
    rejected: 'rejected'
  }

  enum status: STATUSES
end
