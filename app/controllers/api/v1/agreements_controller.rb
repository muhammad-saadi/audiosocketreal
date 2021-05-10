class Api::V1::AgreementsController < Api::BaseController
  before_action :authenticate_user!

  def index
    render json: current_user.agreements
  end

end
