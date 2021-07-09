class AddCountryToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :country, :string
  end
end
