class TaxInformation < ApplicationRecord
  belongs_to :artist_profile, touch: true

  has_many_attached :tax_forms
end
