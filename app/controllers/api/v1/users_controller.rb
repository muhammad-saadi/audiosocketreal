class Api::V1::UsersController < Api::BaseController
  validate_role roles: ['manager'], only: %i[managers]

  before_action :set_user, only: %i[accept_invitation authenticate_token]

  skip_before_action :authenticate_user!, except: %i[managers]

  def managers
    render json: User.manager
  end

  def accept_invitation
    if @user.update(invitation_params)
      render json: { auth_token: AuthenticateUser.new({ email: @user.email, password: invitation_params[:password], role: params[:role] }).call }
    else
      raise ExceptionHandler::ValidationError.new(@user.errors, 'Error accepting invitation.')
    end
  end

  def authenticate_token
    render json: @user, serializer: Api::V1::UserTokenSerializer
  end

  def forgot_password
    @user = User.find_by!(email: params[:email])
    @token = @user.send_reset_password_instructions
    raise ExceptionHandler::ValidationError.new(@user.errors.to_h, 'Error resetting password.') unless @user.errors.blank?

    render json: 'Email Sent'
  end

  def reset_password
    @user = User.reset_password_by_token(password_params)
    if @user.errors.empty?
      render json: 'Password reset successfully'
    else
      raise ExceptionHandler::ValidationError.new(@user.errors.to_h, 'Error resetting password.')
    end
  end

  private

  def set_user
    @user = User.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def invitation_params
    params.permit(:password, :password_confirmation)
  end

  def password_params
    params.permit(:reset_password_token, :password, :password_confirmation, :role)
  end
end
