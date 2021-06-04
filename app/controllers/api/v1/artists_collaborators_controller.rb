class Api::V1::ArtistsCollaboratorsController < Api::BaseController
  include Api::V1::Docs::ArtistsCollaboratorsDoc

  validate_role roles: ['artist'], only: %i[update_access destroy]
  validate_role roles: ['collaborator'], only: %i[update_status]

  skip_before_action :authenticate_user!, only: %i[authenticate_token]

  before_action :set_artists_collaborator_by_token, only: %i[authenticate_token]
  before_action :set_artists_collaborator_by_id, only: %i[update_status]
  before_action :set_artists_collaborator_by_collaborator_id, only: %i[update_access destroy]

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
      render json: current_user.collaborators_details.includes(:collaborator), each_serializer: Api::V1::CollaboratorSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artists_collaborator.errors.to_h, 'Error updating collaborator.')
    end
  end

  param_group :doc_destroy_artists_collaborator
  def destroy
    raise ExceptionHandler::BadRequest, 'Cannot delete collaborator' unless @artists_collaborator.collaborator.tracks.blank?

    if @artists_collaborator.destroy
      render json: current_user.collaborators_details.includes(:collaborator), each_serializer: Api::V1::CollaboratorSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artists_colaborator.errors.to_h, 'Error deleting collaborator.')
    end
  end

  private

  def set_artists_collaborator_by_token
    @artists_collaborator = ArtistsCollaborator.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end

  def set_artists_collaborator_by_id
    @artists_collaborator = current_user.artists_details.find(params[:id])
  end

  def set_artists_collaborator_by_collaborator_id
    @artists_collaborator = current_user.collaborators_details.find_by_collaborator_id!(params[:collaborator_id])
  end
end
