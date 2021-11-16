class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: %i[show favorite unfavorite]
  skip_before_action :authenticate_consumer!, only: %i[show index]

  def index
    @tracks = Track.search(params[:query], params[:query_type], params[:filters], params[:order_by], params[:ids], params[:direction])

    render json: @tracks.pagination(pagination_params)
  end

  def show
    render json: @track
  end

  def upload_track_search
    @tracks = AimsApiService.aims_tracks(params[:file], 'file')

    render json: @tracks
  end

  def similar_tracks
    @tracks = AimsApiService.aims_tracks(params[:id], 'id')

    render json: @tracks
  end

  def favorite
    current_consumer.favorite_follow!(@track, 'favorite')
    render json: { status: "Track added to favorite" }
  end

  def unfavorite
    if current_consumer.favorite_unfollow!(@track, 'favorite')
      render json: { status: "Track removed from favorite" }
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error in unfavoriting track.')
    end
  end

  private

  def set_track
    @track = Track.includes(filters: [:parent_filter, { sub_filters: :sub_filters }]).find(params[:id])
  end
end
