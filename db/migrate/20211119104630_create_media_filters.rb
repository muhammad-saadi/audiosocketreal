class CreateMediaFilters < ActiveRecord::Migration[6.1]
  def self.up
    add_column :filters, :kind, :string

    Filter.update_all(kind: 'Track')

    rename_table :track_filters, :media_filters
    add_reference :media_filters, :filterable, polymorphic: true

    MediaFilter.update_all(filterable_type: 'Track')
    MediaFilter.update_all("filterable_id=track_id")

    remove_reference :media_filters, :track
  end

  def self.down
    add_reference :media_filters, :track

    MediaFilter.update_all("track_id=filterable_id")

    remove_reference :media_filters, :filterable, polymorphic: true
    rename_table :media_filters, :track_filters

    remove_column :filters, :kind, :string
  end
end
