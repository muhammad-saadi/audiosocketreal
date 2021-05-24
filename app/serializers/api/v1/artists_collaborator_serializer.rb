class Api::V1::ArtistsCollaboratorSerializer < ActiveModel::Serializer
  attributes :id, :status, :password, :agreements, :token

  belongs_to :artist, class_name: 'User'

  def password
    object.collaborator.encrypted_password.present?
  end

  def agreements
    #to be change depends upon agreements to be given
    object.collaborator.users_agreements && object.collaborator.users_agreements.joins(:agreement).where('agreement.agreement_type': [Agreement::TYPES[:exclusive], Agreement::TYPES[:non_exclusive]]).pluck(:status).all?('accepted')
  end

  def token
    object.collaborator.encoded_id
  end
end
