class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_user!, only: :managers

  def managers
    render json: User.manager
  end
end
