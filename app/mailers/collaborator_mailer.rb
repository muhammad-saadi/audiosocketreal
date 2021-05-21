class CollaboratorMailer < ApplicationMailer
  def new_user_mail(email)
    token = User.find_by(email: email).encoded_id
    @path = "#{ENV['FRONTAPP_URL']}/accept-invitation/#{token}"
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audio socket collaborator invitation',
      body: "<a href=#{@path}>Click here</a>"
    )
  end

  def existing_user_mail(id, email)
    @collaborator = ArtistsCollaborator.find(id)
    @path = "#{ENV['FRONTAPP_URL']}/artists_collaborator/#{id}"
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audio socket collaborator invitation',
      body: "<a href=#{@path}>Click here</a>"
    )
  end
end
