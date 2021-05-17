class Api::V1::ArtistProfilesController < Api::BaseController
  include Api::V1::Docs::ArtistProfilesDoc

  before_action :authenticate_user!
  before_action :set_artist_profile, only: %i[update]

  param_group :doc_update_artist_profile
  def update
    if @artist_profile.update(artist_profile_params)
      render json: @artist_profile
    else
      raise ExceptionHandler::ValidationError.new(@artist_profile.errors.to_h, 'Error updating artist profile.')
    end
  end

  private

  def set_artist_profile
    @artist_profile = ArtistProfile.find(params[:id])
  end

  def artist_profile_params
    params.permit(:cover_image, :banner_image, :sounds_like, :bio, :key_facts, :contact, additional_images: [], social: [])
  end
end
