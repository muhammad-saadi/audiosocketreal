module Mediable
  extend ActiveSupport::Concern

  included do
    has_many :playlist_tracks, as: :listable, dependent: :destroy
    has_many :tracks, through: :playlist_tracks, source: :mediable, source_type: 'Track'
    has_many :sfxes, through: :playlist_tracks, source: :mediable, source_type: 'Sfx'
  end
end
