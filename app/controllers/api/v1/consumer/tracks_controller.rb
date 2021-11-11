class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: [:show]
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @tracks = Track.filter(params[:search_key], params[:search_query]).order(params[:order_by]).pagination(pagination_params)
    render json: @tracks.includes(filters: [:parent_filter, { sub_filters: :sub_filters }], file_attachment: :blob)
  end

  def show
    render json: @track
  end

  private

  def set_track
    @track = Track.includes(filters: [:parent_filter, { sub_filters: :sub_filters }]).find(params[:id])
  end
end
