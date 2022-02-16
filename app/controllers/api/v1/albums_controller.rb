class Api::V1::AlbumsController < Api::BaseController
  validate_role roles: ['artist']

  before_action :set_album, only: %i[update show destroy update_artwork bulk_upload_tracks]

  def index
    @albums = current_user.albums.pagination(pagination_params)
    render json: @albums.includes(tracks: [:publishers, :file_attachment, { artists_collaborators: :collaborator }]),
           meta: { count: @albums.count }, adapter: :json
  end

  def create
    @album = current_user.albums.new(album_params)
    if @album.save
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error creating album.')
    end
  end

  def update
    if @album.update(album_params)
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album.')
    end
  end

  def show
    render json: @album
  end

  def destroy
    if @album.destroy
      render json: current_user.albums
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error deleting album.')
    end
  end

  def update_artwork
    if @album.update(artwork_params)
      render json: @album
    else
      raise ExceptionHandler::ValidationError.new(@album.errors.to_h, 'Error updating album artwork.')
    end
  end

  def bulk_upload_tracks
    raise ExceptionHandler::ArgumentError.new('File attachment limit of 20 files exceeded') if params[:files].length > 20
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
