class Sfx < ApplicationRecord
  include Pagination
  include Favoritable
  include Media

  validates :title, :file, :keyword, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }

  has_one_attached :file

  after_save :set_duration

  SFX_EAGER_LOAD_COLS = { filters: [:parent_filter, :sfxes, sub_filters: [:sfxes, sub_filters: [:sfxes, :sub_filters]]], file_attachment: :blob }.freeze

  def self.to_zip
    all.each_with_index.inject([]) do |zip_list, (sfx, index)|
      next zip_list unless sfx.file.attached?

      file_name = zip_list.pluck(1).include?(sfx.filename) ? sfx.filename(" (#{index})") : sfx.filename
      zip_list << [sfx.file, file_name]
    end
  end

  def set_duration
    return if self.attachment_changes.empty?

    filepath = self.attachment_changes['file'].attachable.path
    self.update_columns(duration: FFMPEG::Movie.new(filepath).duration&.round(2))
  end

  def filename(index = '')
     name = file.filename.to_s
     (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end
end
