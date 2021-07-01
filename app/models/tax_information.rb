class TaxInformation < ApplicationRecord
  belongs_to :artist_profile

  validates :ssn, presence: true, format: { with: /\A\d[\d-]*\d\z/i }
end
