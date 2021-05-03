class User < ApplicationRecord
  include Roles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :auditions, foreign_key: 'assignee_id', dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }, presence: true

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
