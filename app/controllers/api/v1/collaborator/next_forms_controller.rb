class Api::V1::Collaborator::NextFormsController < Api::V1::Collaborator::BaseController
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create_next_form]

  def create_next_form
    render json: NextFormService.create_form(@current_artist)
  end
end
