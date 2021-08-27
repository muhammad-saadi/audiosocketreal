class ArtistsCollaborator < ApplicationRecord
  include Pagination

  belongs_to :artist, class_name: 'User', optional: true
  belongs_to :collaborator, class_name: 'User', optional: true

  has_many :track_writers
  has_many :tracks, through: :track_writers, dependent: :restrict_with_exception

  has_one :collaborator_profile, dependent: :destroy

  validate :collaborator_invite
  validates_uniqueness_of :artist_id, scope: [:collaborator_id]

  accepts_nested_attributes_for :collaborator_profile

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

  def send_status_update_mail
    return unless accepted? || rejected?

    CollaboratorMailer.invitation_status_update(id).deliver_later if status_previously_changed?
  end

  def collaborator_email
    collaborator.email
  end

  private

  def collaborator_invite
    errors.add(:base, 'Could not invite yourself as collaborator') if artist_id == collaborator_id
  end
end
