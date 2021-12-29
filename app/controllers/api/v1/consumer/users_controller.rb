class Api::V1::Consumer::UsersController < Api::V1::Consumer::BaseController
  before_action :set_artist, only: :show

  def index
    @artists = User.artist
    render json: @artists, meta: { count: @artists.size }, adapter: :json
  end

  def show
    render json: @artist
  end

  private

  def set_artist
    @artist = User.artist.find(params[:id])
  end
end
