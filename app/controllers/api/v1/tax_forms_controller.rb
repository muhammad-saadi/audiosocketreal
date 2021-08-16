class Api::V1::TaxFormsController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[submit_tax_form]
  skip_before_action :authorize_request, only: %i[submit_tax_form]

  def create_tax_form
    render json: TaxIdService.create_form(current_user)
  end

  def submit_tax_form
    TaxIdService.submit_form(tax_params, param_tax_id)
  end

  private

  def tax_params
    params.require(:form).permit(:token, :reference)
  end

  def param_tax_id
    tax_id = params.require(:form).require(:w9).permit(:ssn, :ein)
    add_dashes(tax_id)
  end

  private

  def add_dashes(tax_id)
    return tax_id[:ssn].insert(3, '-').insert(6, '-') if tax_id[:ssn].present?

    tax_id[:ein]&.insert(2, '-')
  end
end
