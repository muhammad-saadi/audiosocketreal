class AddLyricsToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :lyrics, :text
    add_column :tracks, :explicit, :boolean
  end
end
