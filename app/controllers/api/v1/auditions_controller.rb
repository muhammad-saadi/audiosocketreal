class Api::V1::AuditionsController < Api::BaseController
  before_action :authenticate_user!, only: %i[index]

  def index
    @auditions = Audition.filter(filter_params)
    render json: @auditions.includes(:genres, :audition_musics), meta: { count: @auditions.count }, adapter: :json
  end

  def create
    @audition = Audition.new(audition_params)
    @audition.status_updated_at = DateTime.now

    if @audition.save
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error creating audition.')
    end
  end

  def assign_manager
    @audition = Audition.find(params[:id])
    if @audition.update(assignee: User.find(params[:assignee_id]))
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error assigning audition to user.')
    end
  end
  private

  def audition_params
    params.require(:audition).permit(:first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
                                     :how_you_know_us, :status, :status_updated_at, :note, audition_musics: [:track_link], genre_ids: [])
  end

  def filter_params
    params.permit(:status, :page, :per_page, :pagination)
  end
end
