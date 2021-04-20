class AuditionMailer < ApplicationMailer
  def response_mail(email, content)
    mail(content_type: "text/html", to: email, subject: 'Audio socket audition response', body: content)
  end

  def assignee_mail(email, id)
    mail(content_type: "text/html", to: email, subject: 'Audio socket notification', body: "You have assigned audition##{id}")
  end
end
