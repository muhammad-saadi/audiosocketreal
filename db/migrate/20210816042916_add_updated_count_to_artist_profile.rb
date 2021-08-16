class AddUpdatedCountToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :update_count, :integer, default: 0
  end
end
