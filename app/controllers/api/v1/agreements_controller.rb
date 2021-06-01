class Api::V1::AgreementsController < Api::BaseController
  include UserValidator
  include Api::V1::Docs::AgreementsDoc

  validate_role roles: ['artist', 'collaborator']

  param_group :doc_agreements
  def index
    render json: current_user.agreements
  end
end
