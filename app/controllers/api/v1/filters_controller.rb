class Api::V1::FiltersController < Api::BaseController

  skip_before_action :authenticate_user!

  def index
    @filter = Filter.where(filter_id: nil)
    render json: @filter
  end
end
