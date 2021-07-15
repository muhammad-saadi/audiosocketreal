class AddEmailToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :email, :string
  end
end
