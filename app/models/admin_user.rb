class AdminUser < ApplicationRecord
  include Roles

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  ROLES = {
    admin: 'admin',
    accountant: 'accountant'
  }.freeze

  enum_roles roles: ROLES
end
