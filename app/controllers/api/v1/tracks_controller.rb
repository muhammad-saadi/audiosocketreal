class Api::V1::TracksController < Api::BaseController
  include Api::V1::Docs::GenresDoc

  before_action :authenticate_user!
  before_action :set_audition

  def create
    @track = @album.tracks.new(track_params)
    if @track.save
      render json: @track
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error creating track.')
    end
  end

  private

  def track_params
    params.permit(:title, :file)
  end

  def set_audition
    @album = current_user.albums.find(params[:album_id])
  end
end
