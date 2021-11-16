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
    if current_consumer.favorite_unfollow!(@artist, 'follow')
      render json: { status: "Artist unfollowed" }
    else
      raise ExceptionHandler::ValidationError.new(@artist.errors.to_h, 'Error in unfollowing artist.')
    end
  end

  private

  def set_artist
    @artist = User.artist.find(params[:id])
  end
end
