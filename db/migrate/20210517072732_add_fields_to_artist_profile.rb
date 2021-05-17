class AddFieldsToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :sounds_like, :string
    add_column :artist_profiles, :bio, :text
    add_column :artist_profiles, :key_facts, :text
    add_column :artist_profiles, :contact, :text
    add_column :artist_profiles, :social, :text, array: true, default: []
  end
end
