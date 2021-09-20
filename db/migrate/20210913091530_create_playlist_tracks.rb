class CreatePlaylistTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :playlist_tracks do |t|
      t.text :note
      t.references :track
      t.references :listable, polymorphic: true

      t.timestamps
    end
  end
end
