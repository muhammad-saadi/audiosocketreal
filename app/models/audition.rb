class Audition < ApplicationRecord
  validates :first_name, :last_name, :email, :artist_name, :reference_company, presence: true
  validate :email_uniqueness

  STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected',
    accepted: 'accepted',
  }.freeze

  enum status: STATUSES

  def self.filter(params)
    result = params[:status].present? ? where(status: params[:status]) : all
    return result if params[:pagination] == 'false'

    result.pagination(params[:page], params[:per_page])
  end

  def self.pagination(page = 1, per_page = PER_PAGE)
    page(page).per(per_page)
  end

  private

  def email_uniqueness
    return if email.blank?
    return unless Audition.where('email ILIKE ? AND status != ?', email, 'rejected').any?

    errors.add(:email, 'is already taken.')
  end
end
