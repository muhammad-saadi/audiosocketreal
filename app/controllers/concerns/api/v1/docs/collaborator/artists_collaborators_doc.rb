module Api::V1::Docs::Collaborator::ArtistsCollaboratorsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_destroy_artists_collaborator do
      api :DELETE, '/v1/collaborator/artists_collaborators/:id', 'Delete a collaborator'
      param :artist_id, :number, desc: 'ID of the artist', required: true
      param :id, :number, desc: 'Id of the artists_collaborator'
    end
  end
end
