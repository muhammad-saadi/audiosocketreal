class ContactInformation < ApplicationRecord
  belongs_to :artist_profile, touch: true

  validates :name, :phone, :email, :street, :postal_code, :city, :state, :country, presence: true
  validates :email, email: true
  validates :phone, numericality: true
end
