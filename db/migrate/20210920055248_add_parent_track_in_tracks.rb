class AddParentTrackInTracks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tracks, :parent_track
  end
end
