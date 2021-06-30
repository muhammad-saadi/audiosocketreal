class ArtistProfile < ApplicationRecord
  belongs_to :user

  has_one :contact_information, dependent: :destroy
  has_one :payment_information, dependent: :destroy
  has_one :tax_information, dependent: :destroy

  has_many :notes, as: :notable, dependent: :destroy

  accepts_nested_attributes_for :contact_information
  accepts_nested_attributes_for :payment_information
  accepts_nested_attributes_for :tax_information

  validates :profile_image, :banner_image, :additional_images, blob: { content_type: :image }
  validates :bio, length: { maximum: 400 }

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
    self.social.join("\n") unless self.social.nil?
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
end
