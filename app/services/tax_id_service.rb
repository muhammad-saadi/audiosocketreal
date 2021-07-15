require 'open-uri'

class TaxIdService < HttPartyService
  base_uri 'https://api.taxid.pro'

  def self.create_form(current_user)
    current_user = current_user
    key= ENV['TAXID_KEY']
    thankYouUrl = ENV['THANK_YOU_URL']
    formNumber = current_user.form_number
    reference = current_user.artist_profile.id

    @options = { body: { key: key, thankYouUrl: thankYouUrl, formNumber: formNumber, reference: reference } }

    self.post("/formRequests", @options).parsed_response
  end

  def self.submit_form(params)
    form_token = params[:token]
    pdf_link = HttPartyService.get("https://api.taxid.pro/forms/#{form_token}/pdf",{body: { key: ENV['TAXID_KEY'] }}).parsed_response
    tax_information = TaxInformation.find_or_create_by(artist_profile_id: params[:reference])
    tax_information.tax_forms.attach(io: open(pdf_link['pdf']), filename: 'taxform.pdf')
  end
end
