module Api::V1::FavoritesFollowingConcern
  extend ActiveSupport::Concern

  def set_klass(favorite_followable)
    case favorite_followable
    when 'track'
      Track.includes(filters: [:parent_filter, { sub_filters: :sub_filters }])
    when 'consumer_playlist'
      current_consumer.consumer_playlists.includes(ConsumerPlaylist.eagerload_columns)
    when 'artist'
      User.artist
    end
  end
end
