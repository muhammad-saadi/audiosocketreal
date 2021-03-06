class Album < ApplicationRecord
  include Pagination
  include TrackDetailsExporter

  belongs_to :user

  has_many :tracks, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  has_one_attached :artwork

  validates :name, :artwork, presence: true
  validates :artwork, blob: { content_type: :image }, dimension: { min: 353..353, message: 'must be minimum 353x353' }

  def upload_tracks(files)
    messages = []
    files.each do |file|
      track = Track.new(file: file, title: file.original_filename)
      track.valid?
      if track.errors[:file].present?
        messages.append({ file: file.original_filename, error: track.errors[:file] })
      else
        tracks << track
        track.save(validate: false)
      end
    end
    messages
  end

  def formatted_release_date
    release_date&.strftime('%B %d, %Y')
  end
end
