class ArtistProfile < ApplicationRecord
  belongs_to :user, touch: true

  has_one :contact_information, dependent: :destroy
  has_one :payment_information, dependent: :destroy
  has_one :tax_information, dependent: :destroy

  has_many :notes, as: :notable, dependent: :destroy
  has_many :artists_genres, dependent: :destroy
  has_many :genres, through: :artists_genres

  accepts_nested_attributes_for :contact_information
  accepts_nested_attributes_for :payment_information
  accepts_nested_attributes_for :tax_information

  validates :name, :email, :country, :profile_image, :banner_image, presence: true
  validates :profile_image, :banner_image, :additional_images, blob: { content_type: :image }
  validates :profile_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }
  validates :bio, length: { maximum: 400 }
  validates :email, email: true, allow_blank: true
  validates :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true

  before_save :reset_ipi
  before_update :increment_update_count

  STATUSES = {
    pending: 'pending',
    approved: 'approved'
  }.freeze

  IMAGE_STATUSES = {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze

  enum status: STATUSES
  enum profile_image_status: IMAGE_STATUSES, _prefix: :profile_image_status
  enum banner_image_status: IMAGE_STATUSES, _prefix: :banner_image_status

  has_one_attached :profile_image
  has_one_attached :banner_image
  has_many_attached :additional_images

  attr_accessor :social_raw

  def social_raw
    social&.join("\n")
  end

  def social_raw=(values)
    self.social = []
    self.social = values.split("\n")
  end

  def contact_information=(attributes)
    self.contact_information_attributes = attributes.merge({ id: contact_information&.id })
  end

  def payment_information=(attributes)
    self.payment_information_attributes = attributes.merge({ id: payment_information&.id })
  end

  def tax_information=(attributes)
    self.tax_information_attributes = attributes.merge({ id: tax_information&.id })
  end

  def genre_names
    genres.map(&:name).join(', ')
  end

  def increment_update_count
    increment(:update_count)
  end
end
