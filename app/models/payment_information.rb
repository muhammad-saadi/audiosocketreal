class PaymentInformation < ApplicationRecord
  belongs_to :artist_profile

  validates :payee_name, :bank_name, :routing, :account_number, presence: true
  validates :paypal_email, presence: true, unless: :united_states?, allow_blank: false

  private

  def united_states?
    artist_profile.contact_information.country.downcase == 'united states'
  end
end
