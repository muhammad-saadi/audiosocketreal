class CreateArtistProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :artist_profiles do |t|
      t.string :name
      t.boolean :exclusive

      t.references :user
      t.timestamps
    end
  end
end
