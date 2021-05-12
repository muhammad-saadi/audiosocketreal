class Api::V1::AuditionsController < Api::BaseController
  include Api::V1::Docs::AuditionsDoc

  before_action :authenticate_user!, except: %i[create]
  before_action :set_user, only: %i[assign_manager bulk_assign_manager]
  before_action :set_audition, only: %i[assign_manager update_status]

  around_action :wrap_transaction, only: %i[bulk_update_status]

  param_group :doc_auditions
  def index
    @filtered_auditions = Audition.filter(filter_params[:search_key], filter_params[:search_query])
    @auditions = @filtered_auditions.filter_by_status(filter_params[:status]).pagination(filter_params)
    render json: @auditions.ordered_by_status.ordered.includes(:genres, :audition_musics), meta: count_details, adapter: :json
  end

  param_group :doc_create_audition
  def create
    @audition = Audition.new(audition_params)
    @audition.status_updated_at = DateTime.now

    if @audition.save
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error creating audition.')
    end
  end

  param_group :doc_update_status
  def update_status
    @audition.exclusive = params[:exclusive]

    if @audition.update(status: params[:status])
      @audition.send_email(params[:content])
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error updating audition.')
    end
  end

  param_group :doc_bulk_update_status
  def bulk_update_status
    @auditions = Audition.where(id: params[:ids]).includes(:audition_musics, :genres)
    if @auditions.update(status: params[:status]) && @auditions.all? { |aud| aud.errors.blank? }
      @auditions.map { |audition| audition.send_email(params[:content]) }
      render json: @auditions
    else
      raise ExceptionHandler::ValidationError.new(@auditions.map(&:errors).map(&:to_hash).reduce(&:merge), 'Error updating audition.')
    end
  end

  param_group :doc_assign_manager
  def assign_manager
    if @audition.update(assignee: @user, remarks: params[:remarks])
      @audition.notify_assignee
      render json: @audition
    else
      raise ExceptionHandler::ValidationError.new(@audition.errors.to_h, 'Error assigning audition to user.')
    end
  end

  param_group :doc_bulk_assign_manager
  def bulk_assign_manager
    @auditions = Audition.where(id: params[:audition_ids]).includes(:audition_musics, :genres)
    if @auditions.update(assignee: @user, remarks: params[:remarks])
      @auditions.map(&:notify_assignee)
      render json: @auditions
    else
      raise ExceptionHandler::ValidationError.new({}, 'Error assigning auditions to user.')
    end
  end

  param_group :email_template
  def email_template
    return render json: { params[:status].to_sym => EMAIL_TEMPLATES[params[:status].to_sym] } if params[:status].present?

    render json: EMAIL_TEMPLATES
  end

  private

  def set_audition
    @audition = Audition.find(params[:id])
  end

  def set_user
    @user = User.find_by_id(params[:assignee_id])
    raise ExceptionHandler::ValidationError.new({}, 'User should be a manager') if @user.present? && !@user.manager?
  end

  def audition_params
    params.require(:audition).permit(:first_name, :last_name, :email, :artist_name, :reference_company, :exclusive_artist,
                                     :how_you_know_us, :status, :status_updated_at, :sounds_like, :remarks, audition_musics: [:track_link], genre_ids: [])
  end

  def filter_params
    params.permit(:status, :page, :per_page, :pagination, :search_key, :search_query)
  end

  def count_details
    {
      total: @filtered_auditions.not_deleted.count,
      pending: @filtered_auditions.pending.count,
      approved: @filtered_auditions.approved.count,
      accepted: @filtered_auditions.accepted.count,
      rejected: @filtered_auditions.rejected.count,
      deleted: @filtered_auditions.deleted.count
    }
  end
end
