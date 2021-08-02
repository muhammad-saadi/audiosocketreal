class AddDetailsToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :composer, :string
    add_column :tracks, :admin_note, :string
    add_column :tracks, :description, :string
    add_column :tracks, :language, :string
    add_column :tracks, :instrumental, :boolean
    add_column :tracks, :key, :string
    add_column :tracks, :bpm, :string
  end
end
