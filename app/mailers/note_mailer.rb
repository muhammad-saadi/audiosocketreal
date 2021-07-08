class NoteMailer < ApplicationMailer
  def notify_note_status(id)
    @note = Note.find(id)

    mail(
      content_type: "text/html",
      to: @note.user.email,
      subject: 'Audiosocket note status'
    )
  end
end
