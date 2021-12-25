class Api::V1::Consumer::UsersController < Api::V1::Consumer::BaseController
  before_action :set_artist, only: %i[show]

  def index
    @artists = User.artist
    render json: @artists, meta: { count: @artists.size }, adapter: :json
  end

  def show
    render json: @artist
  end

  private

  def set_artist
    @artist = User.artist.find_by(id: params[:id])
    response_msg(404, 'Could not find artist with given id') if @artist.blank?
  end
end
