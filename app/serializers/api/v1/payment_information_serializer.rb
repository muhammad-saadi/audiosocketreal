class Api::V1::PaymentInformationSerializer < ActiveModel::Serializer
  attributes :payee_name, :bank_name, :routing, :account_number, :paypal_email
end
