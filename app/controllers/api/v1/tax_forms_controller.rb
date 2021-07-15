class Api::V1::TaxFormsController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[submit_tax_form]
  skip_before_action :authorize_request, only: %i[submit_tax_form]

  def create_tax_form
    render json: TaxIdService.create_form(current_user)
  end

  def submit_tax_form
    TaxIdService.submit_form(tax_params)
  end

  private

  def tax_params
    params.require(:form).permit(:token, :reference)
  end
end
