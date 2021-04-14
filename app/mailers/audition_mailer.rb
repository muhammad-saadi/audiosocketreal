class AuditionMailer < ApplicationMailer
  def response_mail(email, content)
    byebug
    mail(to: email, subject: 'Audio socket audition response', body: content)
  end
end
