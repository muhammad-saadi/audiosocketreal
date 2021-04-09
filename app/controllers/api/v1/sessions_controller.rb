class Api::V1::SessionsController < Api::BaseController
  def create
    render json: { auth_token: AuthenticateUser.new(authentication_params).call }
  end

  private

  def authentication_params
    params.permit(:email, :password)
  end
end
