module ActiveAdminHelper
  def collaborators_status_list
    ArtistsCollaborator.statuses.keys.map { |key| [key.humanize, key] }
  end

  def collaborators_access_list
    ArtistsCollaborator.accesses.keys.map { |key| [key.humanize, key] }
  end

  def agreement_types
    Agreement.agreement_types.keys.map { |key| [key.titleize, key] }
  end

  def images_status_list
    ArtistProfile::IMAGE_STATUSES.keys.map { |key| [key.to_s.titleize, key] }
  end

  def notes_status_list
    Note.statuses.keys.map { |key| [key.titleize, key] }
  end

  def tracks_status_list
    Track.statuses.keys.map { |key| [key.titleize, key] }
  end

  def users_agreements_status_list
    UsersAgreement.statuses.keys.map { |key| [key.titleize, key] }
  end

  def users_agreement_roles_list
    UsersAgreement.roles.keys.map { |key| [key.titleize, key] }
  end

  def agreements_list
    Agreement.all.map { |agreement| ["Agreement ##{agreement.id}", agreement.id] }
  end

  def collaborators_details_list(user)
    user.collaborators_details.includes(:collaborator).map { |u| [u.collaborator.email, u.id] }
  end

  def artists_collaborators_list
    ArtistsCollaborator.all.map { |artists_collaborator| ["Artist Collaborator ##{artists_collaborator.id}", artists_collaborator.id] }
  end
end
