class Api::V1::TaxInformationSerializer < ActiveModel::Serializer
  attributes :tax_forms

  def tax_forms
    object.tax_forms.each do |form|
      UrlHelpers.rails_blob_url(form)
    end
  end
end
