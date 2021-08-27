class UsersAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :agreement

  validates_uniqueness_of :agreement_id, scope: [:user_id, :role]

  STATUSES = {
    pending: 'pending',
    accepted: 'accepted',
    rejected: 'rejected'
  }.freeze

  ROLES = {
    artist: 'artist',
    collaborator: 'collaborator'
  }.freeze

  enum status: STATUSES
  enum  role: ROLES

  scope :artists, -> { where(role: ROLES[:artist]) }
  scope :collaborators, -> { where(role: ROLES[:collaborator]) }
  scope :by_role, ->(role) { where(role: role) }

  def self.by_agreements
    joins(:agreement).where('agreement.agreement_type': [Agreement::TYPES[:exclusive], Agreement::TYPES[:non_exclusive]])
  end

  def self.accepted?(role)
    by_role(role).by_agreements.pluck(:status).all?('accepted')
  end
end
