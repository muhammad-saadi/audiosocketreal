class Api::V1::Consumer::TracksController < Api::V1::Consumer::BaseController
  before_action :set_track, only: :show
  skip_before_action :authenticate_consumer!, only: %i[show index]
  before_action :authenticate_consumer!, only: %i[show index add_download_track get_downloaded_tracks], if: :consumer_signed_in?

  def index
    @tracks = Track.approved.search(params[:query], params[:query_type], params[:filters], params[:order_by], params[:ids], params[:direction])
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

  def add_download_track
    consumer_medium = ConsumerMedium.download_media(params[:id], @current_consumer, "Track")

    if consumer_medium.save!
      @track = Track.find(params[:id])

      render json: { message: "#{@track.title} is successfully downloaded"}
    else
       raise ExceptionHandler::ValidationError.new(@current_consumer.errors.to_h, 'Error downloading track.')
    end
  end

  def get_downloaded_tracks
    download_track_list = ConsumerMedium.downloaded_media(@current_consumer.id, 'Track')

    if download_track_list.present?
      render json: current_consumer.downloaded_tracks.includes(Track::TRACK_EAGER_LOAD_COLS)
    else
      render json: { message: "nothing downloaded yet" }
    end
  end

  private

  def set_track
    @track = Track.approved.includes(Track::TRACK_EAGER_LOAD_COLS).find(params[:id])
  end

  def consumer_signed_in?
    request.headers['auth-token'].present?
  end
end
