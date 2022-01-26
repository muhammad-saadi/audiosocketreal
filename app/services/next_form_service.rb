require 'open-uri'

class NextFormService
  BASE_URL = "https://api.nextform.app"

  def self.create_form(current_user)
    key = ENV['NEXT_FORM_KEY']
    type = current_user.form_number
    reference = current_user.artist_profile.id
    name = current_user.artist_profile.name
    successUrl = ENV['SUCCESS_URL']
    email = ENV['NEXT_FORM_SIGNER_EMAIL']

    @options = { body: { reference: reference, successUrl: ENV['SUCCESS_URL'], signerEmail: email, formType: type, formData: { name: name } }, headers: { Authorization: key } }

    response(HTTParty.post("#{BASE_URL}/sessions", @options).parsed_response)
  end

  def self.submit_form(params, tax_id)
    form_id = params[:id]
    pdf_link = HTTParty.get("#{BASE_URL}/forms/#{form_id}/pdf", { headers: { Authorization: ENV['NEXT_FORM_KEY'] } }).parsed_response
    tax_information = TaxInformation.find_or_create_by(artist_profile_id: params[:reference])
    tax_information.update(tax_id: tax_id) if tax_id.present?
    tax_information.tax_forms.attach(io: open(pdf_link['pdf']), filename: 'taxform.pdf')
  end

  def self.response(response)
    return response if response.is_a?(Hash)

    { error: response }
  end
end
