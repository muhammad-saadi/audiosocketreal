class Api::V1::UsersAgreementsController < Api::BaseController
  include Api::V1::Docs::UsersAgreementsDoc

  before_action :authenticate_user!
  before_action :set_user_agreement, only: :update_status

  param_group :doc_users_agreements
  def index
    render json: current_user.users_agreements
  end
end
