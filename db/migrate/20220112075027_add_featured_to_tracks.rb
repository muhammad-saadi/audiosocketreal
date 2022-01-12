class AddFeaturedToTracks < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :featured, :boolean, default: false
  end
end
