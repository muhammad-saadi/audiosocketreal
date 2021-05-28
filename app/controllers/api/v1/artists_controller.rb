class Api::V1::ArtistsController < Api::BaseController
  include Api::V1::Docs::ArtistsDoc

  before_action :authenticate_user!
  before_action :set_artist_profile, only: %i[update_profile show_profile]

  param_group :doc_update_profile
  def update_profile
    if @artist_profile.update(artist_profile_params)
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
    render json: current_user.collaborators
  end

  private

  def set_artist_profile
    raise ExceptionHandler::InvalidAccess, Message.invalid_access unless current_user.artist?
    @artist_profile = current_user.artist_profile
  end

  def artist_profile_params
    params.permit(:cover_image, :banner_image, :sounds_like, :bio, :key_facts,
                  contact_information: %i[name street postal_code city state country],
                  payment_information: %i[payee_name bank_name routing account_number paypal_email],
                  tax_information: %i[ssn], additional_images: [], social: [])
  end

  def collaborator_params
    params.permit(:name, :email, :agreements, :access)
  end
end