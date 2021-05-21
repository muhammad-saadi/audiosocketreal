class ContactInformation < ApplicationRecord
  belongs_to :artist_profile

  validates :name, :street, :postal_code, :city, :state, :country, presence: true
end
