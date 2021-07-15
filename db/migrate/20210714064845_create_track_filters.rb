class CreateTrackFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :track_filters do |t|
      t.references :track
      t.references :filter

      t.timestamps
    end
  end
end
