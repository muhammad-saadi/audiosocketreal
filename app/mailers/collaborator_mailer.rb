class CollaboratorMailer < ApplicationMailer
  def invitation_mail(current_user_id, id, email)
    @artists_collaborator = ArtistsCollaborator.find(id)
    @current_user = User.find(current_user_id)
    @path = "#{ENV['FRONTAPP_URL']}/accept-collaborator-invitation/#{@artists_collaborator.encoded_id}"
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audio socket collaborator invitation',
    )
  end
end
