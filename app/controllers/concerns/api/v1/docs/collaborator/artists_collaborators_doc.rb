module Api::V1::Docs::Collaborator::ArtistsCollaboratorsDoc
  extend ActiveSupport::Concern

  included do
    include Api::V1::Docs::Collaborator

    def_param_group :doc_destroy_artists_collaborator do
      api :DELETE, '/v1/collaborator/artists_collaborators/:id', 'Delete a collaborator'
      param :artist_id, :number, desc: 'ID of the artist', required: true
      param :id, :number, desc: 'Id of the artists_collaborator'
    end

    def_param_group :doc_update_artists_collaborator do
      api :PATCH, '/v1/collaborator/artists_collaborators/:id', 'Update collaborator'
      param :artist_id, :number, desc: 'ID of the artist', required: true
      param :id, :number, desc: 'ID of collaborator', required: true
      param :access, ArtistsCollaborator.accesses.keys, desc: 'New value of access', required: true
      param :collaborator_profile_attributes, Hash, desc: 'Collaborator profile attributes', required: true do
        param :pro, String, desc: 'PRO of collaborator'
        param :ipi, String, desc: 'CAE/IPI of collaborator'
        param :different_registered_name, String, desc: 'Is PRO knows by different name?'
      end
    end
  end
end
