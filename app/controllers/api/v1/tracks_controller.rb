class Api::V1::TracksController < Api::BaseController
  validate_role roles: ['artist']

  before_action :set_album
  before_action :set_track, only: %i[update show destroy]

  def index
    @tracks = @album.tracks.pagination(pagination_params)

    render json: @tracks.includes(:user, track_publishers: [publisher: :publisher_users], artists_collaborators: :collaborator, filters: [sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob), meta: { count: @tracks.size }, adapter: :json
  end

  def create
    @track = @album.tracks.new(track_params)
    if @track.save
      render json: @track
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error creating track.')
    end
  end

  def update
    if @track.update(track_params)
      render json: @track
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error updating track.')
    end
  end

  def show
    render json: @track
  end

  def destroy
    if @track.destroy
      render json: @album.tracks
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error deleting track.')
    end
  end

  private

  def track_params
    params.permit(:title, :file, :public_domain, :status, :lyrics, :explicit, :composer, :description,
                  :language, :instrumental, :key, :bpm, :admin_note, :parent_track_id, track_publishers: %i[publisher_id percentage],
                                                                                       track_writers: %i[artists_collaborator_id percentage])
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_track
    @track = @album.tracks.find(params[:id])
  end
end
