class Api::V1::FiltersController < Api::BaseController
  skip_before_action :authorize_request
  skip_before_action :authenticate_user!

  def index
    render json: Filter.parent_filters.includes(sub_filters: [sub_filters: :sub_filters])
  end

  def sub_filters
    render json: Filter.where(id: params[:ids]).includes(:sub_filters).map(&:filter_options).flatten(1)
  end
end
