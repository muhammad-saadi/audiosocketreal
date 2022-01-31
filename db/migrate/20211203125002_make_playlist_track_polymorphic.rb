class MakePlaylistTrackPolymorphic < ActiveRecord::Migration[6.1]
  def change
    remove_reference :playlist_tracks, :track
    add_reference :playlist_tracks, :mediable, polymorphic: true
  end
end
