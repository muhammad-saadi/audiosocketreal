class RemoveContactFromArtistProfile < ActiveRecord::Migration[6.1]
  def change
    remove_column :artist_profiles, :contact, :text
  end
end
