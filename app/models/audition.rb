class Audition < ApplicationRecord
  validates :first_name, :last_name, :email, :artist_name, :reference_company, :status, :status_updated_at, presence: true
  validate :email_uniqueness

  STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected',
    accepted: 'accepted',
  }.freeze

  enum status: STATUSES

  private

  def email_uniqueness
    return if email.blank?
    return unless Audition.where('email ILIKE ? AND status != ?', email, 'rejected').any?

    errors.add(:email, 'is already taken.')
  end

  def self.filter(status, page, per_page, pagination)
    return all.pagination(page, per_page, pagination) if status.blank?
    
    where(status: status).pagination(page, per_page, pagination)
  end

  def self.pagination(page = 1, per_page = 10, pagination)
    return all if pagination == 'false'

    page(page).per(per_page)
  end
end
