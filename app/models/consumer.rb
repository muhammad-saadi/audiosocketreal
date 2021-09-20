class Consumer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  after_create :create_default_folders

  has_one :consumer_profile, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :consumer_playlists, through: :folders

  validates :first_name, :last_name, presence: true

  accepts_nested_attributes_for :consumer_profile

  attr_accessor :skip_password_validation

  def self.authenticate(email, password)
    user = Consumer.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def encoded_id
    JsonWebToken.encode({ consumer_id: id })
  end

  private

  def password_required?
    return false if skip_password_validation

    super
  end
end
