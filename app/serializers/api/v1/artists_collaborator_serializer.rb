class Api::V1::ArtistsCollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :status, :meta

  belongs_to :artist, class_name: 'User'

  def meta
    collaborator = object.collaborator
    {
      password: collaborator.encrypted_password.present?,
      agreements: collaborator.users_agreements && object.collaborator.users_agreements.joins(:agreement).where('agreement.agreement_type': [Agreement::TYPES[:exclusive], Agreement::TYPES[:non_exclusive]]).pluck(:status).all?('accepted'),
      token: collaborator.encoded_id
    }
  end
end
