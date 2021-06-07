class CollaboratorMailer < ApplicationMailer
  def invitation_mail(current_user_id, id, email)
    @artists_collaborator = ArtistsCollaborator.find(id)
    @current_user = User.find(current_user_id)
    @path = "#{ENV['FRONTAPP_URL']}/accept-collaborator-invitation/#{@artists_collaborator.encoded_id}"
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audiosocket collaborator invitation'
    )
  end

  def invitation_status_update(id)
    @artists_collaborator = ArtistsCollaborator.find(id)
    mail(
      to: @artists_collaborator.artist.email,
      subject: 'Audiosocket collaborator invitation response'
    )
  end
end
