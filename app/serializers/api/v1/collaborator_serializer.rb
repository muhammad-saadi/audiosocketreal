class Api::V1::CollaboratorSerializer < BaseSerializer
  attributes :id, :first_name, :last_name, :email, :access, :status

  def access
    current_user.collaborator_artists.find_by(collaborator_id: object.id).access
  end

  def status
    current_user.collaborator_artists.find_by(collaborator_id: object.id).status
  end
end
