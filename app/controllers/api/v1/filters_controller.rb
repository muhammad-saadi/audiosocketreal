class Api::V1::FiltersController < Api::BaseController

  skip_before_action :authenticate_user!

  def index
    render json: Filter.parent_filters
  end
end
