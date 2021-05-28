class Api::V1::ArtistsCollaboratorsController < Api::CollaboratorsController
  include Api::V1::Docs::ArtistsCollaboratorsDoc

  skip_before_action :authenticate_user!, :validate_role, only: %i[authenticate_token]
  before_action :set_artists_collaborator_by_token, only: %i[authenticate_token]
  before_action :set_artists_collaborator_by_id, only: %i[update_status]

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

  private

  def set_artists_collaborator_by_token
    @artists_collaborator = ArtistsCollaborator.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def set_artists_collaborator_by_id
    @artists_collaborator = current_user.artist_collaborators.find(params[:id])
  end
end
