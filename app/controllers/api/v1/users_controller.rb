class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_user!, only: :managers
  before_action :set_user, only: %i[accept_invitation authenticate_token]

  def managers
    render json: User.manager
  end

  def accept_invitation
    if @user.update(invitation_params)
      render json: { auth_token: AuthenticateUser.new({email: @user.email, password: invitation_params[:password]}).call }
    else
      raise ExceptionHandler::ValidationError.new(@user, 'Error accepting invitation.')
    end
  end

  def authenticate_token
    render json: @user, serializer: Api::V1::UserTokenSerializer
  end

  private

  def set_user
    @user = User.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def invitation_params
    params.permit(:password, :password_confirmation)
  end
end
