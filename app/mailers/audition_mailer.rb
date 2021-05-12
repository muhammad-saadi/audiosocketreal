class AuditionMailer < ApplicationMailer
  def response_mail(id, content)
    @audition = Audition.find(id)
    @content = content
    if @audition.approved?
      token = User.find_by(email: @audition.email).encoded_id
      @path = "#{ENV['FRONTAPP_URL']}/accept-invitation/#{token}"
    end

    mail(
      content_type: "text/html",
      from: @audition.email_config[:from],
      to: @audition.email,
      cc: @audition.email_config[:cc],
      subject: @audition.email_subject
    )
  end

  def assignee_mail(id, remarks, current_user_id)
    @audition = Audition.find(id)
    @remarks = remarks
    @current_user = User.find(current_user_id)
    mail(
      content_type: "text/html",
      to: @audition.assignee.email,
      subject: 'Audio socket notification'
    )
  end
end
