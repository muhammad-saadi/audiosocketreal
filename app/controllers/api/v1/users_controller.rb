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
      render json: { auth_token: AuthenticateUser.new({email: @user.email, password: invitation_params[:password], role: params[:role]}).call }
    else
      raise ExceptionHandler::ValidationError.new(@user.errors, 'Error accepting invitation.')
    end
  end

  param_group :doc_authenticate_token
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
