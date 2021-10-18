class AddOrderToPlaylistTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :playlist_tracks, :order, :integer
  end
end
