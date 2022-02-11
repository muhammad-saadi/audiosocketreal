class CreateLicenseTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :license_tracks do |t|
      t.references :license
      t.references :track
      
      t.timestamps
    end
  end
end
