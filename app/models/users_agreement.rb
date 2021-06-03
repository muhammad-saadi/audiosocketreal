class UsersAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :agreement

  validates_uniqueness_of :agreement_id, scope: [:user_id]

  STATUSES = {
    pending: 'pending',
    accepted: 'accepted',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
end
