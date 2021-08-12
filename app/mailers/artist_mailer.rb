class ArtistMailer < ApplicationMailer
  def alert_accountant(id, changes)
    @user = User.find(id)
    @changes = changes
    mail(
      to: ENV['ACCOUNTANT_EMAIL'],
      subject: 'Artist update alert'
    )
  end
end
