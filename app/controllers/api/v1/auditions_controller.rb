class Api::V1::AuditionsController < Api::BaseController
  def index
    @auditions = Audition.filter(filter_params)
    render json: @auditions, meta: { count: @auditions.count }, adapter: :json
  end

  def create
    @audition = Audition.new(audition_params)
    @audition.status_updated_at = DateTime.now

    if @audition.save
      render json: @audition
    else
      raise ExceptionHandler::ValidationError, @audition.errors.to_h
    end
  end

  private

  def audition_params
    params.require(:audition).permit(:first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
                                     :sounds_like, :genre, :how_you_know_us, :status, :status_updated_at, :note)
  end

  def filter_params
    params.permit(:status, :page, :per_page, :pagination)
  end
end
