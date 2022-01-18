class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: :show
  skip_before_action :authenticate_consumer!, only: %i[show index]
  before_action :authenticate_consumer!, only: %i[show index], if: :consumer_signed_in?

  def index
    @tracks = Track.approved.search(params[:query], params[:query_type], params[:filters], params[:order_by], params[:ids], params[:direction])
    @favorite_track_ids = current_consumer&.favorite_followables('Track', 'favorite')&.ids

    render json: @tracks.pagination(pagination_params), meta: { total_track_count: @tracks.size, favorite_tracks_ids: @favorite_track_ids }, adapter: :json
  end

  def show
    render json: @track
  end

  def upload_track_search
    @tracks = AimsApiService.aims_tracks(params[:file], 'file')

    render json: @tracks, meta: { query_type: 'AIMS' }, adapter: :json
  end

  def similar_tracks
    @tracks = AimsApiService.aims_tracks(params[:id], 'id')

    render json: @tracks
  end

  private

  def set_track
    @track = Track.approved.includes(Track::TRACK_EAGER_LOAD_COLS).find(params[:id])
  end

  def consumer_signed_in?
    request.headers['auth-token'].present?
  end
end
