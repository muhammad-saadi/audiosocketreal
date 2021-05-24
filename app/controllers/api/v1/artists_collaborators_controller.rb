class Api::V1::ArtistsCollaboratorsController < Api::BaseController
  include Api::V1::Docs::ArtistsCollaboratorsDoc

  before_action :set_artists_collaborator

  param_group :doc_authenticate_token
  def authenticate_token
    render json: @artists_collaborator
  end

  private

  def set_artists_collaborator
    @artists_collaborator = ArtistsCollaborator.find_by(JsonWebToken.decode(params[:token], ExceptionHandler::TokenError.new('Invalid Token.')))
  end
end
