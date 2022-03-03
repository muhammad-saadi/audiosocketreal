module Api::V1::FavoritesFollowingConcern
  extend ActiveSupport::Concern

  def set_klass(favorite_followable)
    case favorite_followable
    when 'track'
      Track
    when 'consumer_playlist'
      current_consumer.consumer_playlists.includes(ConsumerPlaylist::PLAYLIST_EAGER_LOAD_COLS)
    when 'artist'
      User.artist
    when 'sfx'
      Sfx
    end
  end
end