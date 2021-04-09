class Audition < ApplicationRecord
  validate :email_uniqueness, on: :create
  validates :first_name, :last_name, :email, :artist_name, :reference_company, presence: true
  validates_length_of :audition_musics, maximum: 4, message: 'cannot be more than 4.'

  has_many :audition_musics, dependent: :destroy
  has_many :auditions_genres, dependent: :destroy
  has_many :genres, through: :auditions_genres
  belongs_to :assignee, class_name: 'User', optional: true

  accepts_nested_attributes_for :audition_musics, allow_destroy: true

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

  def self.pagination(page, per_page)
    page(page.presence || 1).per(per_page.presence || PER_PAGE)
  end

  def audition_musics=(attributes)
    self.audition_musics_attributes = attributes
  end

  private

  def email_uniqueness
    return if email.blank?
    return unless Audition.where('email ILIKE ? AND status != ?', email, 'rejected').any?

    errors.add(:email, 'is already taken.')
  end
end
