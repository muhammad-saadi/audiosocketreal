class Api::V1::TracksController < Api::BaseController
  include Api::V1::Docs::TracksDoc

  before_action :authenticate_user!
  before_action :set_audition
  before_action :set_track, only: %i[update show]

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

  private

  def track_params
    params.permit(:title, :file)
  end

  def set_audition
    @album = current_user.albums.find(params[:album_id])
  end

  def set_track
    @track = @album.tracks.find(params[:id])
  end
end
