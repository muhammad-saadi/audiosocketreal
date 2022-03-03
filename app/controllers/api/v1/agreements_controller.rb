class Api::V1::AgreementsController < Api::BaseController
  validate_role roles: ['artist', 'collaborator']

  def index
    render json: current_user.agreements
  end
end
