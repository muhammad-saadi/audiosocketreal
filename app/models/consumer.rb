class Consumer < ApplicationRecord
  include RequestLimitConcern
  include FavoriteFollower
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_one :consumer_profile, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :consumer_playlists, dependent: :destroy

  validates :first_name, :last_name, presence: true

  accepts_nested_attributes_for :consumer_profile

  attr_accessor :skip_password_validation

  PLAYLIST_LIMIT = 100
  FOLDER_LIMIT = 100

  define_request_limits types: { folder: FOLDER_LIMIT, playlist: PLAYLIST_LIMIT }

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

  def self.filter_eagerload_columns
    { filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob }
  end

  def self.track_eagerload_columns
    [:alternate_versions, filter_eagerload_columns]
  end

  def self.consumer_playlist_eagerload_columns
    { banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob] }
  end

  private

  def password_required?
    return false if skip_password_validation

    super
  end
end
