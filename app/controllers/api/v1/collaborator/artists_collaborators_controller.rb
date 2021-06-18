class Api::V1::Collaborator::ArtistsCollaboratorsController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::ArtistsCollaboratorsDoc

  allow_access roles: ['collaborator'], access: %w[write], only: %i[update destroy]

  before_action :set_artists_collaborator, only: %i[update destroy]

  param_group :doc_update_artists_collaborator
  def update
    if @artists_collaborator.update(artists_collaborator_params)
      render json: @current_artist.collaborators_details.includes(:collaborator).ordered, each_serializer: Api::V1::CollaboratorSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artists_collaborator.errors.to_h, 'Error updating collaborator.')
    end
  end

  param_group :doc_destroy_artists_collaborator
  def destroy
    if @artists_collaborator.destroy
      render json: @current_artist.collaborators_details.includes(:collaborator), each_serializer: Api::V1::CollaboratorSerializer
    else
      raise ExceptionHandler::ValidationError.new(@artists_colaborator.errors.to_h, 'Error deleting collaborator.')
    end
  end

  private

  def set_artists_collaborator
    @artists_collaborator = @current_artist.collaborators_details.find(params[:id])
  end

  def artists_collaborator_params
    params.permit(:access, collaborator_profile_attributes: %i[pro ipi different_registered_name])
  end
end
