class ArtistsCollaborator < ApplicationRecord
  include Pagination

  belongs_to :artist, class_name: "User", optional: true
  belongs_to :collaborator, class_name: "User", optional: true

  validate :collaborator_invite
  validates_uniqueness_of :artist_id, scope: [:collaborator_id]

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

  scope :by_access, -> (access) { where(access: access) }
  scope :ordered, -> { order(created_at: :desc) }

  def encoded_id
    JsonWebToken.encode({ id: id })
  end

  def self.filter_artists(key, query)
    ransack("artist_#{key}_cont": query).result
  end

  def self.filter_by_access(access)
    return all if access.blank?

    by_access(access)
  end

  private

  def collaborator_invite
    errors.add(:base, 'Could not invite yourself as collaborator') if artist_id == collaborator_id
  end
end
