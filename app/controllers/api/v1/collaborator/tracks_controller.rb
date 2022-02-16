class Api::V1::Collaborator::TracksController < Api::V1::Collaborator::BaseController
  allow_access roles: ['collaborator'], access: %w[read write], only: %i[index show]
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create update destroy]

  before_action :set_album
  before_action :set_track, only: %i[update show destroy]

  def index
    @tracks = @album.tracks.pagination(pagination_params)
    render json: @tracks.includes(%i[publisher file_attachment], artists_collaborator: :collaborator),
           meta: { count: @tracks.count }, adapter: :json, each_serializer: Api::V1::TrackSerializer
  end

  def create
    @track = @album.tracks.new(track_params)
    if @track.save
      render json: @track, serializer: Api::V1::TrackSerializer
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error creating track.')
    end
  end

  def update
    if @track.update(track_params)
      render json: @track, serializer: Api::V1::TrackSerializer
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error updating track.')
    end
  end

  def show
    render json: @track, serializer: Api::V1::TrackSerializer
  end

  def destroy
    if @track.destroy
      render json: @album.tracks, each_serializer: Api::V1::TrackSerializer
    else
      raise ExceptionHandler::ValidationError.new(@track.errors.to_h, 'Error deleting track.')
    end
  end

  private

  def track_params
    params.permit(:title, :file, :public_domain, :status, :lyrics, :explicit, :parent_track_id, track_publishers: %i[publisher_id percentage],
                                                                              track_writers: %i[artists_collaborator_id percentage])
  end

  def set_album
    @album = @current_artist.albums.find(params[:album_id])
  end

  def set_track
    @track = @album.tracks.find(params[:id])
  end
end
