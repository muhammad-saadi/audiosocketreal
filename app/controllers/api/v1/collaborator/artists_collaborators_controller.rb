class Api::V1::Collaborator::ArtistsCollaboratorsController < Api::V1::Collaborator::BaseController
  include Api::V1::Docs::Collaborator::ArtistsCollaboratorsDoc

  allow_access roles: ['collaborator'], access: %w[write], only: %i[destroy]

  before_action :set_artists_collaborator, only: %i[destroy]

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
end
