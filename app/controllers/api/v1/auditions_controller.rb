class Api::V1::AuditionsController < Api::BaseController
  def index
    render json: Audition.all, meta: { count: Audition.count }, adapter: :json
  end

  def create
    @audition = Audition.new(audition_params)
    @audition.status_updated_at = DateTime.now

    if @audition.save
      return render json: @audition
    else
      raise ExceptionHandler::ValidationError, @audition.errors.full_messages.to_sentence
    end
  end

  private

  def audition_params
    params.require(:audition).permit(:first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
                                     :sounds_like, :genre, :how_you_know_us, :status, :status_updated_at, :note)
  end
end
