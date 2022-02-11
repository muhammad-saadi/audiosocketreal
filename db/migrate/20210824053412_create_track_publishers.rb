class CreateTrackPublishers < ActiveRecord::Migration[6.1]
  def change
    create_table :track_publishers do |t|
      t.references :track
      t.references :publisher
      
      t.timestamps
    end
  end
end
