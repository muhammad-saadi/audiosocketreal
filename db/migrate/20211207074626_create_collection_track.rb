class CreateCollectionTrack < ActiveRecord::Migration[6.1]
  def change
    create_table :collection_tracks do |t|
      t.belongs_to :collection
      t.belongs_to :track
      
      t.timestamps
    end
  end
end
