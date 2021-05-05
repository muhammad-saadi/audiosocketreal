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
    deleted: 'deleted'
  }.freeze

  ORDERED_STATUSES = %w[pending accepted approved rejected].freeze

  scope :ordered_by_status, lambda { |statuses = ORDERED_STATUSES|
    order(Arel.sql("ARRAY_POSITION(ARRAY['#{statuses.join("','")}'], CAST(status AS TEXT))"))
  }
  scope :ordered, -> { order(:created_at) }
  scope :by_status, -> (status) { where(status: status) }

  enum status: STATUSES

  ransack_alias :name, :first_name_or_last_name
  ransack_alias :assignee, :assignee_first_name_or_author_last_name
  ransack_alias :genre, :genres_name

  def self.filter_by_status(status)
    return not_deleted if status.blank?

    by_status(status)
  end

  def self.filter(key, query)
    ransack("#{key}_cont": query).result
  end

  def self.pagination(params)
    return all if params[:pagination] == 'false'

    page(params[:page].presence || 1).per(params[:per_page].presence || PER_PAGE)
  end

  def audition_musics=(attributes)
    self.audition_musics_attributes = attributes
  end

  def send_email(content)
    return unless approved? || rejected?

    AuditionMailer.response_mail(id, content.gsub('[name]', full_name)).deliver_later if status_previously_changed?
  end

  def notify_assignee
    AuditionMailer.assignee_mail(id, remarks, Current.user.id).deliver_later if assignee_id.present? && assignee_id_previously_changed?
  end

  def email_subject
    return 'Your Audiosocket Music Submission' if rejected?

    "Audiosocket x #{artist_name}- We've accepted your submission!"
  end

  def email_config
    return { from: ENV['FROM_REJECTED'] } if rejected?
    return { from: ENV['FROM_APPROVED'], cc: ENV['EXCLUSIVE_CC_EMAIL'] } if approved? && exclusive_artist?

    { from: ENV['FROM_APPROVED'], cc: ENV['NON_EXCLUSIVE_CC_EMAIL'] }
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  private

  def refresh_status_updated
    return unless status_changed?

    self.status_updated_at = DateTime.now
  end

  def email_uniqueness
    return if email.blank?
    return unless Audition.where('email ILIKE ? AND status NOT IN (?)', email, [STATUSES[:rejected], STATUSES[:deleted]]).any?

    errors.add(:email, 'is already taken.')
  end

  def status_validation
    return unless status_changed?
    return unless accepted?

    errors.add(:status, 'Cannot be accepted until it is approved.') if status_was != STATUSES[:approved]
  end
end
