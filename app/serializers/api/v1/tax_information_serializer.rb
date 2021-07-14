class Api::V1::TaxInformationSerializer < BaseSerializer
  attributes :tax_forms

  def tax_forms
    object.tax_forms.map{ |form| UrlHelpers.rails_blob_url(form) }
  end
end
