class PaymentInformation < ApplicationRecord
  belongs_to :artist_profile, touch: true

  validates :payee_name, :bank_name, :routing, :account_number, presence: true, if: :united_states?
  validates :paypal_email, presence: true, unless: :united_states?, allow_blank: false
  validates :paypal_email, email: true, allow_blank: true
  validates :routing, numericality: true, length: { is: 9 }, if: :united_states?
  validates :account_number, numericality: true, if: :united_states?
  US = 'united states'.freeze

  private

  def united_states?
    artist_profile&.contact_information&.country&.downcase == US
  end
end
