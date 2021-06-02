class Api::V1::UsersController < Api::BaseController
  include Api::V1::Docs::UsersDoc

  validate_role roles: ['manager'], only: %i[managers]

  before_action :set_user, only: %i[accept_invitation authenticate_token]

  skip_before_action :authenticate_user!, except: %i[managers]

  param_group :doc_list_managers
  def managers
    render json: User.manager
  end

  param_group :doc_accept_invitation
  def accept_invitation
    if @user.update(invitation_params)
      @user.assign_agreements if @user.artist?
      render json: { auth_token: AuthenticateUser.new({ email: @user.email, password: invitation_params[:password], role: invitation_params[:role] }).call }
    else
      raise ExceptionHandler::ValidationError.new(@user.errors, 'Error accepting invitation.')
    end
  end

  param_group :doc_authenticate_token
  def authenticate_token
    render json: @user, serializer: Api::V1::UserTokenSerializer
  end

  param_group :doc_forgot_password
  def forgot_password
    @user = User.find_by(email: params[:email])
    raise ActiveRecord::RecordNotFound.new('No User found against this email') if @user.blank?

    @token = @user.send_reset_password_instructions
    raise ExceptionHandler::ValidationError.new(@user.errors.to_h, 'Error resetting password.') unless @user.errors.blank?

    render json: 'Email Sent'
  end

  param_group :doc_reset_password
  def reset_password
    @user = User.reset_password_by_token(update_params)
    if @user.errors.empty?
      render json: { auth_token: AuthenticateUser.new({ email: @user.email, password: update_params[:password], role: update_params[:role] }).call }
    else
      raise ExceptionHandler::ValidationError.new(@user.errors.to_h, 'Error resetting password.')
    end
  end

  private

  def set_user
    @user = User.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def invitation_params
    params.permit(:password, :password_confirmation, :role)
  end

  def update_params
    params.permit(:reset_password_token, :password, :password_confirmation, :role)
  end
end
