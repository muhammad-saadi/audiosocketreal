class AuditionMailer < ApplicationMailer
  def response_mail(id, content)
    @audition = Audition.find(id)
    @content = content
    mail(
      content_type: "text/html",
      from: @audition.email_config[:from],
      to: @audition.email,
      cc: @audition.email_config[:cc],
      subject: @audition.email_subject
    )
  end

  def assignee_mail(id, remarks)
    @audition = Audition.find(id)
    @remarks = remarks
    mail(
      content_type: "text/html",
      to: @audition.assignee.email,
      subject: 'Audio socket notification'
    )
  end
end
