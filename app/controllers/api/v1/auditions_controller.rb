class Api::V1::AuditionsController < Api::BaseController
  before_action :authenticate_user!, except: %i[create]
  before_action :set_user, only: %i[assign_manager bulk_assign_managers]
  before_action :set_audition, only: %i[assign_manager update_status]

  around_action :wrap_transaction, only: %i[bulk_update_status]

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

  def update_status
    if @audition.update(status: params[:status])
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error updating audition.')
    end
  end

  def bulk_update_status
    @auditions = Audition.where(id: params[:ids])
    if @auditions.update(status: params[:status])
      render json: @auditions
    else
      raise ExceptionHandler::ValidationError.new(@auditions.map(&:errors).map(&:to_h), 'Error updating audition.')
    end
  end

  def assign_manager
    if @user.manager? && @audition.update(assignee: @user)
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error assigning audition to user.')
    end
  end

  def bulk_assign_managers
    @auditions = Audition.where(id: params[:audition_ids])
    if @user.manager? && @auditions.update(assignee: @user)
      render json: @auditions
    else
      raise ExceptionHandler::ValidationError.new({}, 'Error assigning auditions to user.')
    end
  end

  private

  def set_audition
    @audition = Audition.find(params[:id])
  end

  def set_user
    @user = User.find(params[:assignee_id])
  end

  def audition_params
    params.require(:audition).permit(:first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
                                     :how_you_know_us, :status, :status_updated_at, :sounds_like, :note, audition_musics: [:track_link], genre_ids: [])
  end

  def filter_params
    params.permit(:status, :page, :per_page, :pagination)
  end
end
