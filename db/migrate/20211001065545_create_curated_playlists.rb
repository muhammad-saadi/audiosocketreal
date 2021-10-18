class CreateCuratedPlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :curated_playlists do |t|
      t.string :name
      t.string :category
      t.integer :order
      t.timestamps
    end
  end
end
