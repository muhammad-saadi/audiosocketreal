module Api::V1::Docs::ArtistsCollaboratorsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_authenticate_token do
      api :GET, '/v1/artists_collaborators/authenticate_token', 'Authenticated given token and send status of artists collaborator'
      param :token, String, desc: 'Encoded id of the artists_collaborators', required: true
    end

    def_param_group :doc_update_status do
      api :PATCH, '/v1/artists_collaborators/:id/update_status', 'Accept/Reject a collaborator invitation'
      param :id, :number, desc: 'Id of artists_collaborator', required: true
      param :status, ArtistsCollaborator.statuses.keys, desc: 'New value of status', required: true
    end
  end
end