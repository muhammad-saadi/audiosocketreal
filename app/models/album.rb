class Album < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  has_one_attached :artwork

  validates :name, :release_date, :artwork, presence: true
  validates :artwork, blob: { content_type: :image }, dimension: { min: 353..353, message: 'must be minimum 353x353' }

  def upload_tracks(files)
    messages = []
    files.each do |file|
      file_type = file.path.split('.').pop.downcase
      track = Track.new("#{file_type}_file": file, title: file.original_filename)
      track.valid?
      if track.errors[:"#{file_type}_file"].present?
        messages.append({ "#{file_type}_file": file.original_filename, error: track.errors[:"#{file_type}_file"] })
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
