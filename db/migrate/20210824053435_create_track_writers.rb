class CreateTrackWriters < ActiveRecord::Migration[6.1]
  def change
    create_table :track_writers do |t|
      t.references :track
      t.references :artists_collaborator
      t.timestamps
    end
  end
end
