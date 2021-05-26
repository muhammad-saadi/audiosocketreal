class ArtistProfile < ApplicationRecord
  belongs_to :user

  has_one :contact_information, dependent: :destroy

  accepts_nested_attributes_for :contact_information

  validates :cover_image, :banner_image, :additional_images, blob: { content_type: :image }

  STATUSES = {
    pending: 'pending',
    approved: 'approved'
  }.freeze

  enum status: STATUSES

  has_one_attached :cover_image
  has_one_attached :banner_image
  has_many_attached :additional_images

  def contact_information=(attributes)
    self.contact_information_attributes = attributes.merge({ id: contact_information&.id })
  end
end
