class AddProAndIpiToArtistProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :artist_profiles, :pro, :string
    add_column :artist_profiles, :ipi, :string
  end
end
