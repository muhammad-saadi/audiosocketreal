class Api::V1::Consumer::ConsumersPlaylistsController < Api::V1::Consumer::BaseController
  before_action :set_playlist, only: %i[update rename show destroy add_track]
  before_action :increment_usage, only: :create

  def add_track
    @playlist.tracks << Track.find(params[:track_id])
    render json: { status: "Track added to playlist" }
  end

  def index
    @playlists = current_consumer.consumer_playlists
    render json: @playlists.includes(ConsumerPlaylist.eagerload_columns), meta: { count: @playlists.count }, adapter: :json
  end

  def show
    render json: @playlist
  end

  def create
    @playlist = current_consumer.consumer_playlists.new(playlist_params)
    if @playlist.save
      render json: @playlist
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error creating playlist.')
    end
  end

  def rename
    if @playlist.update(playlist_params)
      render json: @playlist
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error renaming playlist.')
    end
  end

  def update
    if @playlist.update(update_playlist_params)
      render json: @playlist
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error updating playlist.')
    end
  end

  def destroy
    if @playlist.destroy
      render json: current_consumer.consumer_playlists
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error deleting playlist.')
    end
  end

  private

  def set_playlist
    @playlist = current_consumer.consumer_playlists.includes(ConsumerPlaylist.eagerload_columns).find(params[:id])
  end

  def update_playlist_params
    params.permit(:name, :folder_id, :playlist_image, :banner_image, playlist_tracks_attributes: [:id, :track_id, :note, :_destroy] )
  end

  def playlist_params
    params.permit(:name, :folder_id)
  end

  def increment_usage
    current_consumer.increment_playlist_usage!
  end
end