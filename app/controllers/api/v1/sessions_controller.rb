class Api::V1::SessionsController < Api::BaseController
  skip_before_action :authenticate_user!

  def create
    render json: { auth_token: AuthenticateUser.new(authentication_params).call, role: params[:role] }
  end

  private

  def authentication_params
    params.permit(:email, :password, :remember_me, :role)
  end
end
