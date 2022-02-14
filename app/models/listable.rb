module Listable
  extend ActiveSupport::Concern

  included do
    has_many :playlist_tracks, as: :mediable, dependent: :destroy
    has_many :consumer_playlists, through: :playlist_tracks, source: :listable, source_type: 'ConsumerPlaylist'
    has_many :curated_playlists, through: :playlist_tracks, source: :listable, source_type: 'CuratedPlaylist'
  end
end
