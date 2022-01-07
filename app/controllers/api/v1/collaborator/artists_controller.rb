class Api::V1::Collaborator::ArtistsController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::ArtistsDoc

  allow_access roles: ['collaborator'], access: %w[read write], only: %i[show_profile collaborators]
  allow_access roles: ['collaborator'], access: %w[write], only: %i[update_profile invite_collaborator resend_collaborator_invitation]

  before_action :set_artist_profile, only: %i[update_profile show_profile]

  param_group :doc_update_profile
  def update_profile
    if @artist_profile.update(artist_profile_params)
      render json: @artist_profile, serializer: Api::V1::Collaborator::ArtistProfileSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artist_profile.errors.to_h, 'Error updating artist profile.')
    end
  end

  param_group :doc_show_profile
  def show_profile
    render json: @artist_profile, serializer: Api::V1::Collaborator::ArtistProfileSerializer
  end

  param_group :doc_collaborators
  def collaborators
    @collaborators = @current_artist.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer, adapter: :json
  end

  param_group :doc_invite_collaborator
  def invite_collaborator
    @current_artist.invite_collaborator(collaborator_params)
    @collaborators = @current_artist.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer
  end

  def resend_collaborator_invitation
    @artists_collaborator = @current_artist.collaborators_details.find(params[:artists_collaborator_id])

    raise ExceptionHandler::InvalidAccess, 'Invitation already accepted.' if @artists_collaborator.accepted?

    CollaboratorMailer.invitation_mail(@current_artist.id, @artists_collaborator.id, @artists_collaborator.collaborator.email).deliver_later
    @collaborators = @current_artist.collaborators_details.ordered.pagination(pagination_params)
    render json: @collaborators.includes(:collaborator), meta: { count: @collaborators.count }, each_serializer: Api::V1::CollaboratorSerializer
  end

  private

  def set_artist_profile
    @artist_profile = @current_artist.artist_profile
  end

  def artist_profile_params
    params.permit(:email, :profile_image, :banner_image, :sounds_like, :country, :bio, :key_facts, :website_link,
                  :ipi, :pro, contact_information: %i[name email phone street postal_code city state country],
                  payment_information: %i[payee_name bank_name routing account_number paypal_email],
                  additional_images: [], social: [], genre_ids: [])
  end

  def collaborator_params
    params.permit(:name, :email, :agreements, :access, collaborator_profile_attributes: %i[pro ipi different_registered_name])
  end
end
