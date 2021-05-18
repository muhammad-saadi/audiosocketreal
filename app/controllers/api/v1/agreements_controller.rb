class Api::V1::AgreementsController < Api::BaseController
  include Api::V1::Docs::AgreementsDoc

  before_action :authenticate_user!

  param_group :doc_agreements
  def index
    render json: current_user.agreements
  end
end
