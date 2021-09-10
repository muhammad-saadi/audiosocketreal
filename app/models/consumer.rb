class Consumer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_one :consumer_profile, dependent: :destroy

  accepts_nested_attributes_for :consumer_profile

  def self.authenticate(email, password)
    user = Consumer.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
