class AddWebsiteLinkToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :website_link, :string
  end
end
