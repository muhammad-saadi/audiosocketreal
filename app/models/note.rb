class Note < ApplicationRecord
  belongs_to :user
  belongs_to :notable, polymorphic: true

  has_many_attached :files

  scope :by_notable, -> (type, id){ where(notable_type: type, notable_id: id) }

  after_update :notify_user

  STATUSES = {
    pending: 'pending',
    completed: 'completed'
  }.freeze

  enum status: STATUSES

  def notable_name
    return notable.title if notable_type == 'Track'

    notable.name
  end

  def notify_user
    return unless status_previously_changed?
    return unless completed?

    NoteMailer.notify_note_status(id).deliver_later
  end
end
