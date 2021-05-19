class ArtistProfile < ApplicationRecord
  belongs_to :user

  STATUSES = {
    pending: 'pending',
    approved: 'approved'
  }

  enum status: STATUSES

  has_one_attached :cover_image
  has_one_attached :banner_image
  has_many_attached :additional_images
end
