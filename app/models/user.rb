class User < ApplicationRecord
  include Roles

  has_many :auditions, foreign_key: 'assignee_id', dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: { case_sensitive: false }, presence: true

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  ROLES = {
    manager: 'manager',
    artist: 'artist'
  }.freeze

  enum_roles roles: ROLES
end
