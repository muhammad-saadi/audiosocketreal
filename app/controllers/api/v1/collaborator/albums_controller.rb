class Api::V1::Collaborator::AlbumsController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::AlbumsDoc
  allow_access roles: ['collaborator'], access: %w[read write], only: %i[index show]
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create update destroy update_artwork bulk_upload_tracks]

  before_action :set_album, only: %i[update show destroy update_artwork bulk_upload_tracks]

  param_group :doc_albums
  def index
    @albums = @current_artist.albums.pagination(pagination_params)
    render json: @albums.includes(tracks: [:publishers, :wav_file_attachment, :aiff_file_attachment, :mp3_file_attachment, { artists_collaborators: :collaborator }]),
           meta: { count: @albums.count }, each_serializer: Api::V1::AlbumSerializer, adapter: :json
  end

  param_group :doc_create_album
  def create
    @album = @current_artist.albums.new(album_params)
    if @album.save
      render json: @album, serializer: Api::V1::AlbumSerializer
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error creating album.')
    end
  end

  param_group :doc_update_album
  def update
    if @album.update(album_params)
      render json: @album, serializer: Api::V1::AlbumSerializer
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album.')
    end
  end

  param_group :doc_show_album
  def show
    render json: @album, serializer: Api::V1::AlbumSerializer
  end

  param_group :doc_destroy_album
  def destroy
    if @album.destroy
      render json: @current_artist.albums, each_serializer: Api::V1::AlbumSerializer
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error deleting album.')
    end
  end

  param_group :doc_update_artwork
  def update_artwork
    if @album.update(artwork_params)
      render json: @album, serializer: Api::V1::AlbumSerializer
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album artwork.')
    end
  end

  def bulk_upload_tracks
    raise ExceptionHandler::ArgumentError.new('File attachment limit of 20 files exceeded') if params[:files].length > 20
    messages = @album.upload_tracks(params[:files].to_a)
    render json: @album, serializer: Api::V1::AlbumSerializer, adapter: :json,
           meta: { total: params[:files].to_a.count, uploaded: params[:files].to_a.count - messages.count, messages: messages }
  end

  private

  def set_album
    @album = @current_artist.albums.includes(tracks: [:publishers, :wav_file_attachment, :aiff_file_attachment, :mp3_file_attachment, { artists_collaborators: :collaborator }]).find(params[:id])
  end

  def album_params
    params.permit(:name, :release_date, :artwork)
  end

  def artwork_params
    params.permit(:artwork)
  end
end
