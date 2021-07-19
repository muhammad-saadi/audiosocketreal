class Api::V1::Collaborator::TaxFormsController < Api::V1::Collaborator::BaseController
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create_tax_form]

  def create_tax_form
    render json: TaxIdService.create_form(@current_artist)
  end
end
