class Api::V1::AlbumsController < Api::BaseController
  include Api::V1::Docs::AlbumsDoc

  before_action :authenticate_user!
  before_action :set_album, only: %i[update show]

  param_group :doc_albums
  def index
    render json: current_user.albums
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

  private

  def set_album
    @album = current_user.albums.find(params[:id])
  end

  def album_params
    params.permit(:name, :release_date)
  end
end
