class PaymentInformation < ApplicationRecord
  belongs_to :artist_profile

  validates :payee_name, :bank_name, :routing, :account_number, presence: true
  validates :paypal_email, presence: true, unless: :united_states?, allow_blank: false
  validates :paypal_email, email: true, if: -> { paypal_email.present? }
  validates :routing, numericality: true, length: { is: 9 }
  validates :account_number, numericality: true, length: { is: 10 }

  US = 'united states'.freeze

  private

  def united_states?
    artist_profile.contact_information.country.downcase == US
  end
end
