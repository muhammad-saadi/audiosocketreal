class Api::V1::Consumer::ConsumerLicenseSerializer < ActiveModel::Serializer
  attributes :name, :description, :subscription, :consumer_price, :license_pdf

  def name
    object.license.name
  end

  def description
    object.license.description
  end

  def subscription
    object.license.subscription
  end

  def license_pdf
    object.license_pdf.presence && UrlHelpers.rails_blob_url(object.license_pdf)
  end
end
