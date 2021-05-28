class Api::V1::TracksController < Api::ArtistsController
  include Api::V1::Docs::TracksDoc

  before_action :set_album
  before_action :set_track, only: %i[update show destroy]
  before_action :validate_collaborator_and_publisher, only: %i[create update]

  param_group :doc_tracks
  def index
    render json: @album.tracks
  end

  param_group :doc_create_track
  def create
    @track = @album.tracks.new(track_params)
    if @track.save
      render json: @track
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error creating track.')
    end
  end

  param_group :doc_update_track
  def update
    if @track.update(track_params)
      render json: @track
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error updating track.')
    end
  end

  param_group :doc_show_track
  def show
    render json: @track
  end

  param_group :doc_destroy_track
  def destroy
    if @track.destroy
      render json: @album.tracks
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error deleting track.')
    end
  end

  private

  def track_params
    params.permit(:title, :file, :public_domain, :collaborator_id, :publisher_id, :status)
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_track
    @track = @album.tracks.find(params[:id])
  end

  def validate_collaborator_and_publisher
    @collaborator = current_user.collaborators.find(params[:collaborator_id]) if params[:collaborator_id].present?
    @publisher = current_user.publishers.find(params[:publisher_id]) if params[:publisher_id].present?
  end
end
