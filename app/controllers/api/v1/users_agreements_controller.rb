class Api::V1::UsersAgreementsController < Api::BaseController
  include Api::V1::Docs::UsersAgreementsDoc

  validate_role roles: ['artist', 'collaborator']

  before_action :set_user_agreement, only: :update_status

  param_group :doc_users_agreements
  def index
    render json: current_user.users_agreements.by_role(params[:role]).includes(:agreement)
  end

  param_group :doc_update_status
  def update_status
    if @user_agreement.update(status: params[:status], status_updated_at: DateTime.now)
      render json: current_user.users_agreements.by_role(@user_agreement.role)
    else
      raise ExceptionHandler::ValidationError.new(@user_agreement.errors.to_h, 'Error accepting/rejecting agreement.')
    end
  end

  private

  def set_user_agreement
    @user_agreement = current_user.users_agreements.find(params[:id])
  end
end
