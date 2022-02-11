class License < ApplicationRecord
  has_many :license_tracks, dependent: :destroy
  has_many :tracks, through: :license_tracks, source: :mediable, source_type: 'Track'
  has_many :consumer_licenses, dependent: :destroy
  has_many :consumers, through: :consumer_licenses

  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
