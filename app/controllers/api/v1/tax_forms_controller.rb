class Api::V1::TaxFormsController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[submit_tax_form]
  skip_before_action :authorize_request, only: %i[submit_tax_form]

  def create_tax_form
    tax = TaxIdForm.new
    form_url= tax.create_form(current_user).parsed_response
    render json: form_url
  end

  def submit_tax_form
    tax = TaxIdForm.new
    tax.submit_form(params)
  end
end
