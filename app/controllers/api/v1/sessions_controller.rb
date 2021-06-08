class Api::V1::SessionsController < Api::BaseController
  include Api::V1::Docs::SessionsDoc

  skip_before_action :authenticate_user!

  param_group :doc_create_session
  def create
    render json: { auth_token: AuthenticateUser.new(authentication_params).call, role: params[:role] }
  end

  private

  def authentication_params
    params.permit(:email, :password, :remember_me, :role)
  end
end
