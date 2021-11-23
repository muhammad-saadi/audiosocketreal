require 'open-uri'

class TaxIdService
  BASE_URL = "https://api.taxid.pro"

  def self.create_form(current_user)
    key = ENV['TAXID_KEY']
    thankYouUrl = ENV['THANK_YOU_URL']
    formNumber = current_user.form_number
    reference = current_user.artist_profile.id

    @options = { body: { key: key, thankYouUrl: thankYouUrl, formNumber: formNumber, reference: reference } }

    response(HTTParty.post("#{BASE_URL}/formRequests", @options).parsed_response)
  end

  def self.submit_form(params, tax_id)
    form_token = params[:token]
    pdf_link = HTTParty.get("#{BASE_URL}/forms/#{form_token}/pdf", { body: { key: ENV['TAXID_KEY'] } }).parsed_response
    tax_information = TaxInformation.find_or_create_by(artist_profile_id: params[:reference])
    tax_information.update(tax_id: tax_id) if tax_id.present?
    tax_information.tax_forms.attach(io: open(pdf_link['pdf']), filename: 'taxform.pdf')
  end

  def self.response(response)
    return response if response.is_a?(Hash)

    { error: response }
  end
end
