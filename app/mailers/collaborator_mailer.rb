class CollaboratorMailer < ApplicationMailer
  def invitation_mail(id, email)
    @artists_collaborator = ArtistsCollaborator.find(id)
    @path = "#{ENV['FRONTAPP_URL']}/accept_collaborator_invitation/#{@artists_collaborator.encoded_id}"
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audio socket collaborator invitation',
    )
  end
end
