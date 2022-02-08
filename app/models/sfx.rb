class Sfx < ApplicationRecord
  include Pagination
  include Favoritable
  include SoundTrack

  validates :title, :file, :keyword, presence: true

  SFX_EAGER_LOAD_COLS = { filters: [:parent_filter, :sfxes, sub_filters: [:sfxes, sub_filters: [:sfxes, :sub_filters]]], wav_file_attachment: :blob, aiff_file_attachment: :blob, mp3_file_attachment: :blob }.freeze
end
