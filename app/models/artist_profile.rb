class ArtistProfile < ApplicationRecord
  belongs_to :user

  has_one :contact_information, dependent: :destroy

  STATUSES = {
    pending: 'pending',
    approved: 'approved'
  }

  enum status: STATUSES

  has_one_attached :cover_image
  has_one_attached :banner_image
  has_many_attached :additional_images
end
