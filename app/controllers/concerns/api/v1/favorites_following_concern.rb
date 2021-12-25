module Api::V1::FavoritesFollowingConcern
  extend ActiveSupport::Concern

  def set_klass(favorite_followee)
    case favorite_followee
    when 'track'
      favorite_followee = Track.includes(filters: [:parent_filter, { sub_filters: :sub_filters }])
    when 'consumer_playlist'
      favorite_followee = current_consumer.consumer_playlists.includes(ConsumerPlaylist.eagerload_columns)
    when 'artist'
      favorite_followee = User.artist
    end
  end
end
