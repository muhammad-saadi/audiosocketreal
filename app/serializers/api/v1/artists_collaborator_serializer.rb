class Api::V1::ArtistsCollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :status, :access, :meta

  belongs_to :artist, class_name: 'User'

  def meta
    collaborator = object.collaborator
    {
      password: collaborator.encrypted_password.present?,
      agreements: collaborator.agreements_accepted?('collaborator'),
      token: collaborator.encoded_id
    }
  end
end
