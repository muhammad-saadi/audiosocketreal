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

  attr_accessor :roles_raw

  def roles_raw
    roles&.join("\n")
  end

  def roles_raw=(values)
    self.roles = []
    self.roles = values.split("\r\n").intersection(ROLES.values)
  end
end
