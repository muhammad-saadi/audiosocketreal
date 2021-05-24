module Api::V1::Docs::ArtistsCollaboratorsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs

    def_param_group :doc_authenticate_token do
      api :GET, '/v1/artists_collaborators/authenticate_token', 'Authenticated given token and send status of artists collaborator'
      param :token, String, desc: 'Encoded id of the artists_collaborators', required: true
    end
  end
end
