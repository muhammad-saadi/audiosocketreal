class CreateConsumerPlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :consumer_playlists do |t|
      t.string :name
      t.references :folder

      t.timestamps
    end
  end
end
