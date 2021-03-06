class Api::V1::CollaboratorSerializer < BaseSerializer
  attributes :id, :first_name, :last_name, :email, :access, :status

  has_one :collaborator_profile, serializer: Api::V1::CollaboratorProfileSerializer

  def first_name
    object.collaborator.first_name
  end

  def last_name
    object.collaborator.last_name
  end

  def email
    object.collaborator.email
  end
end
