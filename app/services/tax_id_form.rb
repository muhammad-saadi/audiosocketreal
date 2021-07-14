require 'open-uri'

class TaxIdForm
  include HTTParty
  base_uri 'https://api.taxid.pro'

  def initialize; end

  def create_form(current_user)
    current_user = current_user
    key= ENV['TAXID_KEY']
    thankYouUrl = "http://artists.square63.net/profile"
    formNumber = "w8ben"
    formNumber = "w9" if current_user.artist_profile.country == "United States"
    reference = current_user.artist_profile.id

    @options = { body: { key: key, thankYouUrl: thankYouUrl, formNumber: formNumber, reference: reference } }

    self.class.post("/formRequests", @options)
  end

  def submit_form(params)
    form_token = params[:form][:token]
    pdf_link = HTTParty.get("https://api.taxid.pro/forms/#{form_token}/pdf",{body: { key: ENV['TAXID_KEY'] }}).parsed_response
    tax_information = TaxInformation.find_or_create_by(artist_profile_id: params[:form][:reference])
    tax_information.tax_forms.attach(io: open(pdf_link['pdf']), filename: 'taxform.pdf')
  end
end
