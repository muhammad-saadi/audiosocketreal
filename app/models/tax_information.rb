class TaxInformation < ApplicationRecord
  belongs_to :artist_profile

  validates :ssn, presence: true, numericality: true
end
