class Api::V1::Consumer::CuratedPlaylistsController < Api::V1::Consumer::BaseController
  before_action :set_playlist, only: :show

  def index
    @playlists = CuratedPlaylist.search(params[:query])
    render json: @playlists.includes(CuratedPlaylist.eagerload_columns), meta: { count: @playlists.count }, adapter: :json
  end

  def show
    render json: @playlist
  end

  private

  def set_playlist
    @playlist = CuratedPlaylist.find(params[:id])
  end
end
