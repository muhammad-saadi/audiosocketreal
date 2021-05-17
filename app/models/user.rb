class User < ApplicationRecord
  include Roles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :auditions, foreign_key: 'assignee_id', dependent: :destroy
  has_one :artist_profile, dependent: :destroy
  has_many :users_agreements, dependent: :destroy
  has_many :agreements, through: :users_agreements

  validates :email, uniqueness: { case_sensitive: false }, presence: true
  validates :password, confirmation: true

  before_save :validate_manager

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  ROLES = {
    manager: 'manager',
    artist: 'artist'
  }.freeze

  enum_roles roles: ROLES

  def self.find_by_id(id)
    return nil if id == 'null'

    find(id)
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def encoded_id
    JsonWebToken.encode({ id: id })
  end

  def assign_agreements
    self.agreements = Agreement.exclusive if self.artist_profile.exclusive?
    self.agreements = Agreement.non_exclusive unless self.artist_profile.exclusive?
  end

  private

  def validate_manager
    return unless roles_was.include?(ROLES[:manager])
    return if manager?
    return if auditions.blank?

    errors.add(:base, 'Cannot remove manager role as auditions are assigned.')
    self.roles = roles_was
    raise ActiveRecord::Rollback
  end
end
