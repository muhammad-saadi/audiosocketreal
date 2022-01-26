class Api::V1::NextFormsController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[submit_next_form]
  skip_before_action :authorize_request, only: %i[submit_next_form]

  def create_next_form
    render json: NextFormService.create_form(current_user)
  end

  def submit_next_form
    NextFormService.submit_form(next_params, param_tax_id)
  end

  private

  def next_params
    params.require(:form).permit(:id, :reference)
  end

  def param_tax_id
    return if params.dig(:form, :data, :ssn).blank?

    tax_id = params.require(:form).require(:data).permit(:ssn, :ein)
    add_dashes(tax_id)
  end

  private

  def add_dashes(tax_id)
    return tax_id[:ssn].insert(3, '-').insert(6, '-') if tax_id[:ssn].present?

    tax_id[:ein]&.insert(2, '-')
  end
end
