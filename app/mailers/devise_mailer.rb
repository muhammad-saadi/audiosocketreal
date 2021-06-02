class DeviseMailer < Devise::Mailer
  layout 'mailer'

  def reset_password_instructions(user, token, opts = {})
    @user = user
    @url = "#{ENV['FRONTAPP_URL']}/reset-password/#{token}"
    opts[:from] = ENV['FROM_EMAIL']
    super
  end
end
