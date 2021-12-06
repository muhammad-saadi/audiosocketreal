class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: [:show]
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @tracks = Track.search(params[:query], params[:query_type], params[:filters], params[:order_by], params[:ids], params[:direction])

    render json: @tracks.pagination(pagination_params)
  end

  def show
    render json: @track
  end

  private

  def set_track
    @track = Track.includes(filters: [:parent_filter, { sub_filters: :sub_filters }]).find(params[:id])
  end
end
