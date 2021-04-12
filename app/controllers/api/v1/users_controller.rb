class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_user!, only: :managers

  def managers
    @users = User.manager
    render json: @users
  end
end
