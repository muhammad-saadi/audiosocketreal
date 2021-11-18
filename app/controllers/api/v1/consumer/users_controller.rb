class Api::V1::Consumer::UsersController < Api::V1::Consumer::BaseController
  before_action :set_artist, only: %i[show follow unfollow]

  def index
    @artists = User.artist
    render json: @artists, meta: { count: @artists.size }, adapter: :json
  end

  def show
    render json: @artist
  end

  def follow
    current_consumer.favorite_follow!(@artist, 'follow')
    render json: { status: "Artist followed" }
  end

  def unfollow
    return render json: { status: "Artist unfollowed" } if current_consumer.favorite_unfollow!(@artist, 'follow')

    raise ExceptionHandler::ValidationError.new(@artist.errors.to_h, 'Error in unfollowing artist.')
  end

  private

  def set_artist
    @artist = User.artist.find_by(id: params[:id])
    failure_response(404, 'Could not find artist with given id') if @artist.blank?
  end
end
