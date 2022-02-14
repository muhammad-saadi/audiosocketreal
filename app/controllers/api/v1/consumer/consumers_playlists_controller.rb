class Api::V1::Consumer::ConsumersPlaylistsController < Api::V1::Consumer::BaseController
  before_action :set_playlist, except: %i[index create]
  before_action :set_media, only: :add_media
  before_action :increment_usage, only: :create

  def add_media
    @playlist.playlist_tracks.build(mediable: @media)

    if @playlist.save
      render json: { status: "#{params[:mediable_type].classify} added to playlist" }
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error adding media to playlist.')
    end
  end

  def index
    @playlists = current_consumer.consumer_playlists

    render json: @playlists.includes(ConsumerPlaylist::PLAYLIST_EAGER_LOAD_COLS), meta: { count: @playlists.count }, adapter: :json
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
      render json: load_playlist_queries.find(@playlist.id)
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error updating playlist.')
    end
  end

  def destroy
    if @playlist.destroy
      render json: load_playlist_queries
    else
      raise ExceptionHandler::ValidationError.new(@playlist.errors.to_h, 'Error deleting playlist.')
    end
  end

  private

  def set_playlist
    return @playlist = load_playlist_queries.find(params[:id]) unless %w[update destroy].include? params[:action]

    @playlist = current_consumer.consumer_playlists.find(params[:id])
  end

  def update_playlist_params
    params.permit(:name, :folder_id, :playlist_image, :banner_image, playlist_tracks_attributes: [:id, :mediable_id, :mediable_type, :note, :_destroy])
  end

  def playlist_params
    params.permit(:name, :folder_id)
  end

  def increment_usage
    current_consumer.increment_playlist_usage!
  end

  def load_playlist_queries
    current_consumer.consumer_playlists.includes(ConsumerPlaylist::PLAYLIST_EAGER_LOAD_COLS)
  end

  def set_media
    @media = params[:mediable_type].classify.constantize.find(params[:mediable_id])
  end
end
