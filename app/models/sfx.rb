class Sfx < ApplicationRecord
  include Pagination
  include Favoritable

  has_many :media_filters, as: :filterable, dependent: :destroy
  has_many :filters, through: :media_filters

  has_one_attached :file

  validates :title, :file, :keyword, presence: true
  validates :file, blob: { content_type: %w[audio/vnd.wave audio/wave audio/aiff audio/x-aiff] }

  after_save :set_duration

  SFX_EAGER_LOAD_COLS = { filters: [:parent_filter, :sfxes, sub_filters: [:sfxes, sub_filters: [:sfxes, :sub_filters]]], file_attachment: :blob }.freeze

  def filename(index = '')
    name = file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end

  def self.to_zip
    all.each_with_index.inject([]) do |zip_list, (sfx, index)|
      next zip_list unless sfx.file.attached?

      file_name = zip_list.pluck(1).include?(sfx.filename) ? sfx.filename(" (#{index})") : sfx.filename
      zip_list << [sfx.file, file_name]
    end
  end

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def set_duration
    return if self.attachment_changes.empty?

    filepath = self.attachment_changes['file'].attachable.path
    self.update_columns(duration: FFMPEG::Movie.new(filepath).duration&.round(2))
  end

  def filter_count
    self.filters.size
  end
end
