class Api::V1::AgreementsController < Api::BaseController
  include Api::V1::Docs::AgreementsDoc

  before_action :authenticate_user!
  before_action :set_user_agreement, only: :update_status

  param_group :doc_agreements
  def index
    render json: current_user.agreements
  end

  param_group :doc_update_status
  def update_status
    if @user_agreement.update(status: params[:status], status_updated_at: DateTime.now)
      render json: current_user.users_agreements
    else
      raise ExceptionHandler::ValidationError.new(@user_agreement.errors.to_h, 'Error accepting/rejecting agreement.')
    end
  end

  private

  def set_user_agreement
    @user_agreement = UsersAgreement.find_by(user: current_user, agreement_id: params[:id])
  end
end
