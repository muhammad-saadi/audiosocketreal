class CreateArtistsGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :artists_genres do |t|
      t.references :artist_profile
      t.references :genre

      t.timestamps
    end
  end
end
