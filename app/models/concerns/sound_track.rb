module SoundTrack
  extend ActiveSupport::Concern

  included do
    has_many :media_filters, as: :filterable, dependent: :destroy
    has_many :filters, through: :media_filters

    has_one_attached :wav_file
    has_one_attached :aiff_file
    has_one_attached :mp3_file

    validates :wav_file, blob: { content_type: %w[audio/vnd.wave audio/wave] }, bitrate: { bits: [16, 24], sample_rate: 48_000 }, size: { less_than_or_equal_to: 50.megabytes }
    validates :aiff_file, blob: { content_type: %w[audio/aiff audio/x-aiff] }, bitrate: { bits: [16, 24], sample_rate: 48_000 }, size: { less_than_or_equal_to: 50.megabytes }
    validates :mp3_file, blob: { content_type: %w[audio/mpeg audio/x-mpeg-3] }, bitrate: { bits: [16, 24], sample_rate: 48_000 }, size: { less_than_or_equal_to: 50.megabytes }

    after_save :set_duration

    AUDIO_TYPES = {
      mp3_file: 'mp3_file',
      aiff_file: 'aiff_file',
      wav_file: 'wav_file'
    }.freeze

    FILE_TYPES = [:wav_file, :aiff_file, :mp3_file].freeze
  end

  def filename(index = '')
    name = mp3_file.filename.to_s
    (title.presence || File.basename(name, File.extname(name))) + index + File.extname(name)
  end

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def self.to_zip
    all.each_with_index.inject([]) do |zip_list, (type, index)|
      next zip_list unless type.mp3_file.attached?

      file_name = zip_list.pluck(1).include?(type.filename) ? type.filename(" (#{index})") : type.filename
      zip_list << [type.wav_file, type.aiff_file, type.mp3_file, file_name]
    end
  end

  def set_duration
    return if self.attachment_changes['mp3_file'].blank?

    mp3_changes = self.attachment_changes['mp3_file'].attachable
    filepath = mp3_changes.is_a?(Hash) ? mp3_changes[:io].path : mp3_changes.path
    self.update_columns(duration: FFMPEG::Movie.new(filepath).duration&.round(2))
  end

  def filter_count
    self.filters.size
  end
end
