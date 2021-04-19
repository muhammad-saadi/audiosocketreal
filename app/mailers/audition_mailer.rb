class AuditionMailer < ApplicationMailer
  def response_mail(email, content)
    mail(to: email, subject: 'Audio socket audition response', body: content)
  end

  def assignee_mail(email, id)
    mail(to: email, subject: 'Audio socket notification', body: "You have assigned audition##{id}")
  end
end
