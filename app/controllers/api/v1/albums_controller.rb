class Api::V1::AlbumsController < Api::BaseController
  include Api::V1::Docs::AlbumsDoc

  validate_role roles: ['artist']

  before_action :set_album, only: %i[update show destroy update_artwork bulk_upload_tracks]

  param_group :doc_albums
  def index
    @albums = current_user.albums.pagination(pagination_params)
    render json: @albums.includes(tracks: [:publishers, :file_attachment, { artists_collaborators: :collaborator }]),
           meta: { count: @albums.count }, adapter: :json
  end

  param_group :doc_create_album
  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error creating album.')
    end
  end

  param_group :doc_update_album
  def update
    if @album.update(album_params)
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album.')
    end
  end

  param_group :doc_show_album
  def show
    render json: @album
  end

  param_group :doc_destroy_album
  def destroy
    if @album.destroy
      render json: current_user.albums
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error deleting album.')
    end
  end

  param_group :doc_update_artork
  def update_artwork
    if @album.update(artwork_params)
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album artwork.')
    end
  end

  def bulk_upload_tracks
    messages = @album.upload_tracks(params[:files].to_a)
    render json: @album, 
           meta: { total: params[:files].to_a.count, uploaded: params[:files].to_a.count - messages.count, messages: messages }, adapter: :json
  end

  private

  def set_album
    @album = current_user.albums.includes(tracks: [:publishers, :file_attachment, { artists_collaborators: :collaborator }]).find(params[:id])
  end

  def album_params
    params.permit(:name, :release_date, :artwork)
  end

  def artwork_params
    params.permit(:artwork)
  end
end
