class Api::V1::AgreementsController < Api::BaseController
  before_action :get_user

  def index
    render json: @user.agreements
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end
end
