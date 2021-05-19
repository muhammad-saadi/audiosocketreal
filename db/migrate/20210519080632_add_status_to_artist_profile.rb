class AddStatusToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :status, :string, default: 'pending'
  end
end
