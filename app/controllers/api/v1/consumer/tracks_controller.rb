class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: :show
  skip_before_action :authenticate_consumer!, only: %i[show index]
  before_action :authenticate_consumer!, only: %i[show index], if: :consumer_signed_in?

  def index
    @tracks = Track.approved.search(params[:ids], params[:direction], search_attributes)
    @favorite_track_ids = current_consumer&.favorite_followables('Track', 'favorite')&.ids

    render json: @tracks.pagination(pagination_params), meta: { total_track_count: @tracks.size, favorite_tracks_ids: @favorite_track_ids, options: 'tracks' }, adapter: :json
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

  def search_attributes
    {
      query: params[:query],
      query_type: params[:query_type],
      filter: params[:filters],
      order_by_attr: params[:order_by],
      explicit: params[:explicit]
    }
  end

  def set_track
    @track = Track.approved.includes(Track::TRACK_EAGER_LOAD_COLS).find(params[:id])
  end

  def consumer_signed_in?
    request.headers['auth-token'].present?
  end
end
