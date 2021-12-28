class CreateLicensesTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :licenses_tracks do |t|
      t.belongs_to :license
      t.belongs_to :track

      t.timestamps
    end
  end
end
