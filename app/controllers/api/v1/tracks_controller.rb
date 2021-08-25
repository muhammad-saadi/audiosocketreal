class Api::V1::TracksController < Api::BaseController
  include Api::V1::Docs::TracksDoc

  validate_role roles: ['artist']

  before_action :set_album
  before_action :set_track, only: %i[update show destroy]

  param_group :doc_tracks
  def index
    @tracks = @album.tracks.pagination(pagination_params)
    render json: @tracks.includes(%i[publishers file_attachment], artists_collaborators: :collaborator), meta: { count: @tracks.count }, adapter: :json
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
    params.permit(:title, :file, :public_domain, :artists_collaborator_id, :status, :lyrics, :explicit,
                  :composer, :description, :language, :instrumental, :key, :bpm, :admin_note, publisher_ids: [], artists_collaborator_ids: [])
  end

  def set_album
    @album = current_user.albums.find(params[:album_id])
  end

  def set_track
    @track = @album.tracks.find(params[:id])
  end
end
