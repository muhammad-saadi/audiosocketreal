class Api::V1::ArtistsCollaboratorsController < Api::BaseController
  include CollaboratorValidator
  include ArtistValidator
  include Api::V1::Docs::ArtistsCollaboratorsDoc

  skip_before_action :authenticate_user!, only: %i[authenticate_token]
  skip_before_action :validate_collaborator, only: %i[authenticate_token update_access]
  skip_before_action :validate_artist, only: %i[authenticate_token update_status]

  before_action :set_artists_collaborator_by_token, only: %i[authenticate_token]
  before_action :set_artists_collaborator_by_id, only: %i[update_status]
  before_action :set_artists_collaborator_by_collaborator_id, only: %i[update_access]

  param_group :doc_authenticate_token
  def authenticate_token
    render json: @artists_collaborator
  end

  param_group :doc_update_status
  def update_status
    if @artists_collaborator.update(status: params[:status])
      render json: @artists_collaborator
    else
      raise ExceptionHandler::ValidationError.new(@artists_collaborator.errors.to_h, 'Error accepting/rejecting collaborator invitation.')
    end
  end

  param_group :doc_update_access
  def update_access
    if @artists_collaborator.update(access: params[:access])
      render json: current_user.collaborators, each_serializer: Api::V1::CollaboratorSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artists_collaborator.errors.to_h, 'Error updating collaborator.')
    end
  end

  private

  def set_artists_collaborator_by_token
    @artists_collaborator = ArtistsCollaborator.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def set_artists_collaborator_by_id
    @artists_collaborator = current_user.artist_collaborators.find(params[:id])
  end

  def set_artists_collaborator_by_collaborator_id
    @artists_collaborator = current_user.collaborators_details.find_by_collaborator_id(params[:collaborator_id])
  end
end
