class Audition < ApplicationRecord
  validate :email_uniqueness, on: :create
  validate :status_validation, on: :update
  validates :first_name, :last_name, :email, :artist_name, :reference_company, :status, presence: true
  validates_length_of :audition_musics, maximum: 4, message: 'cannot be more than 4.'

  has_many :audition_musics, dependent: :destroy
  has_many :auditions_genres, dependent: :destroy
  has_many :genres, through: :auditions_genres

  belongs_to :assignee, -> { manager }, class_name: 'User', optional: true

  accepts_nested_attributes_for :audition_musics, allow_destroy: true

  before_save :refresh_status_updated

  STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected',
    accepted: 'accepted',
  }.freeze

  ORDERED_STATUSES = %w[pending accepted approved rejected].freeze

  scope :order_by_statuses, ->(statuses = ORDERED_STATUSES) { order(Arel.sql("ARRAY_POSITION(ARRAY['#{statuses.join("','")}'], CAST(status AS TEXT))")) }

  enum status: STATUSES

  def self.filter(params)
    result = params[:status].present? ? where(status: params[:status]) : all
    return result.order_by_statuses if params[:pagination] == 'false'

    result.order_by_statuses.pagination(params[:page], params[:per_page])
  end

  def self.pagination(page, per_page)
    page(page.presence || 1).per(per_page.presence || PER_PAGE)
  end

  def audition_musics=(attributes)
    self.audition_musics_attributes = attributes
  end

  def send_email(content)
    return unless accepted? || rejected?

    AuditionMailer.response_mail(email, content).deliver_later
  end

  private

  def refresh_status_updated
    return unless status_changed?

    self.status_updated_at = DateTime.now
  end

  def email_uniqueness
    return if email.blank?
    return unless Audition.where('email ILIKE ? AND status != ?', email, 'rejected').any?

    errors.add(:email, 'is already taken.')
  end

  def status_validation
    return unless status_changed?
    return unless accepted?

    errors.add(:status, 'Cannot be accepted until it is approved.') if status_was != STATUSES[:approved]
  end
end
