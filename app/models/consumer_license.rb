class ConsumerLicense < ApplicationRecord
  belongs_to :consumer
  belongs_to :license

  has_one_attached :license_pdf

  validates_uniqueness_of :consumer_id, scope: %i[license_id track_id]
  validates :consumer_price, numericality: { greater_than_or_equal_to: 0 }
end
