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

    def_param_group :doc_update_access do
      api :PATCH, '/v1/artists_collaborators/:id/update_access', 'Update access for a collaborator'
      param :id, :number, desc: 'ID of collaborator', required: true
      param :access, ArtistsCollaborator.accesses.keys, desc: 'New value of access', required: true
    end

    def_param_group :doc_update_artists_collaborator do
      api :PATCH, '/v1/artists_collaborators/:id', 'Update collaborator'
      param :id, :number, desc: 'ID of collaborator', required: true
      param :access, ArtistsCollaborator.accesses.keys, desc: 'New value of access', required: true
      param :collaborator_profile_attributes, Hash, desc: 'Collaborator profile attributes', required: true do
        param :pro, String, desc: 'PRO of collaborator'
        param :ipi, String, desc: 'CAE/IPI of collaborator'
        param :different_registered_name, [true, false], desc: 'Is PRO knows by different name?'
      end
    end

    def_param_group :doc_destroy_artists_collaborator do
      api :DELETE, "/v1/artists_collaborators/:id", 'Delete a collaborator'
      param :id, :number, desc: 'Id of the artists_collaborator'
    end
  end
end
