class CreateCollectionsTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :collections_tracks do |t|
      t.belongs_to :collection
      t.belongs_to :track

      t.timestamps
    end
  end
end
