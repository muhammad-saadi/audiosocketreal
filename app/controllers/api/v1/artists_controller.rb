class Api::V1::ArtistsController < Api::BaseController
  include Api::V1::Docs::ArtistsDoc

  validate_role roles: ['artist'], except: %i[index]
  validate_role roles: ['collaborator'], only: %i[index]

  before_action :set_artist_profile, only: %i[update_profile show_profile]

  param_group :doc_artists
  def index
    @filtered_artists = current_user.artists_details.non_self_collaborators.includes(artist: :artist_profile, collaborator: :users_agreements).filter_artists(filter_params[:search_key], filter_params[:search_query])
    @artists = @filtered_artists.filter_by_access(filter_params[:access]).pagination(pagination_params)
    render json: @artists, meta: count_details, each_serializer: Api::V1::ArtistsSerializer, adapter: :json
  end

  param_group :doc_update_profile
  def update_profile
    if @artist_profile.update(artist_profile_params)
      @artist_profile.banner_image_status_pending! if params[:banner_image].present?
      @artist_profile.profile_image_status_pending! if params[:profile_image].present?
      render json: @artist_profile
    else
      raise ExceptionHandler::ValidationError.new(@artist_profile.errors.to_h, 'Error updating artist profile.')
    end
  end

  param_group :doc_show_profile
  def show_profile
    render json: @artist_profile
  end

  param_group :doc_invite_collaborator
  def invite_collaborator
    current_user.invite_collaborator(collaborator_params)
    @collaborators = current_user.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer
  end

  def resend_collaborator_invitation
    @artists_collaborator = current_user.collaborators_details.find(params[:artists_collaborator_id])

    raise ExceptionHandler::InvalidAccess, 'Invitation already accepted.' if @artists_collaborator.accepted?

    CollaboratorMailer.invitation_mail(current_user.id, @artists_collaborator.id, @artists_collaborator.collaborator.email).deliver_later
    @collaborators = current_user.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer
  end

  param_group :doc_collaborators
  def collaborators
    @collaborators = current_user.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer, adapter: :json
  end

  private

  def set_artist_profile
    @artist_profile = current_user.artist_profile
  end

  def artist_profile_params
    params.permit(:email, :profile_image, :banner_image, :sounds_like, :bio, :country, :key_facts, :website_link,
                  :pro, :ipi, contact_information: %i[name email phone street postal_code city state country],
                              payment_information: %i[payee_name bank_name routing account_number paypal_email],
                              additional_images: [], social: [], genre_ids: [])
  end

  def collaborator_params
    params.permit(:name, :email, :agreements, :access, collaborator_profile_attributes: %i[pro ipi different_registered_name])
  end

  def filter_params
    params.permit(:access, :search_key, :search_query)
  end

  def count_details
    {
      total: @filtered_artists.count,
      read: @filtered_artists.read.count,
      write: @filtered_artists.write.count
    }
  end
end
