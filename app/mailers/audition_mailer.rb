class AuditionMailer < ApplicationMailer
  def response_mail(audition, content)
    mail(
      content_type: "text/html",
      from: audition.email_config[:from],
      to: audition.email,
      cc: audition.email_config[:cc],
      subject: audition.email_subject,
      body: content
    )
  end

  def assignee_mail(email, id, remarks)
    @id = id
    @remarks = remarks
    mail(
      content_type: "text/html",
      to: email,
      subject: 'Audio socket notification'
    )
  end
end
