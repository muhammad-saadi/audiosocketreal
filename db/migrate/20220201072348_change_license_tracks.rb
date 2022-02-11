class ChangeLicenseTracks < ActiveRecord::Migration[6.1]
  def change
    add_reference :license_tracks, :mediable, polymorphic: true
    remove_reference :license_tracks, :track
  end
end
