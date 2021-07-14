class TaxInformation < ApplicationRecord
  belongs_to :artist_profile

  has_many_attached :tax_forms
end
