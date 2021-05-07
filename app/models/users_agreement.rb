class UsersAgreement < ApplicationRecord
  belongs_to :user
  belongs_to :agreement

  STATUSES = {
    pending: 'pending',
    accepted: 'accepted'
  }.freeze

  enum status: STATUSES
end
