class Api::V1::Collaborator::ArtistsController < Api::BaseController
  include AccessValidator

  validate_role roles: ['collaborator']
  validate_access roles: ['collaborator'], access: %w[read write], only: %i[show_profile]
  validate_access roles: ['collaborator'], access: %w[write], only: %i[update_profile]

  before_action :set_artist_profile, only: %i[update_profile show_profile]

  def update_profile
    if @artist_profile.update(artist_profile_params)
      render json: @artist_profile, serializer: Api::V1::ArtistProfileSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artist_profile.errors.to_h, 'Error updating artist profile.')
    end
  end

  def show_profile
    render json: @artist_profile, serializer: Api::V1::ArtistProfileSerializer
  end

  private

  def set_artist_profile
    @artist_profile = User.find(params[:artist_id]).artist_profile
  end

  def artist_profile_params
    params.permit(:cover_image, :banner_image, :sounds_like, :bio, :key_facts,
                  contact_information: %i[name phone street postal_code city state country],
                  payment_information: %i[payee_name bank_name routing account_number paypal_email],
                  tax_information: %i[ssn], additional_images: [], social: [])
  end
end
