class Api::V1::ArtistsController < Api::BaseController
  include Api::V1::Docs::ArtistsDoc

  validate_role roles: ['artist'], except: %i[index]
  validate_role roles: ['collaborator'], only: %i[index]

  before_action :set_artist_profile, only: %i[update_profile show_profile]

  param_group :doc_artists
  def index
    @filtered_artists = current_user.artists_details.includes(:artist, collaborator: :users_agreements).filter_artists(filter_params[:search_key], filter_params[:search_query])
    @artists = @filtered_artists.filter_by_access(filter_params[:access]).pagination(pagination_params)
    render json: @artists, meta: count_details, each_serializer: Api::V1::ArtistsSerializer, adapter: :json
  end

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
    render json: current_user.collaborators.ordered.pagination(pagination_params)
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
    params.permit(:cover_image, :banner_image, :sounds_like, :bio, :key_facts,
                  contact_information: %i[name phone street postal_code city state country],
                  payment_information: %i[payee_name bank_name routing account_number paypal_email],
                  tax_information: %i[ssn], additional_images: [], social: [])
  end

  def collaborator_params
    params.permit(:name, :email, :agreements, :access)
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
