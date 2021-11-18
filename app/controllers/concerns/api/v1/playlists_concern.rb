module Api::V1::PlaylistsConcern
  extend ActiveSupport::Concern

  def playlists(kind)
    consumer_playlists = current_consumer.favorite_followables('ConsumerPlaylist', kind).includes(Consumer.consumer_playlist_eagerload_columns)
    curated_playlists = current_consumer.favorite_followables('CuratedPlaylist', kind)
    consumer_playlists | curated_playlists
  end
end
