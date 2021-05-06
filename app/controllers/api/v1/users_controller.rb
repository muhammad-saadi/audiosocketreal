class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_user!, only: :managers
  before_action :set_user, only: :accept_invitation

  def managers
    render json: User.manager
  end

  def accept_invitation
    if @user.update(invitation_params)
      render json: "Agreements will be provided here"
    else
      raise ExceptionHandler::ValidationError.new(@user, 'Error setting password.')
    end
  end

  private

  def set_user
    @user = User.find_by(JsonWebToken.decode(params[:token]))
  end

  def invitation_params
    params.permit(:password, :password_confirmation)
  end
end
