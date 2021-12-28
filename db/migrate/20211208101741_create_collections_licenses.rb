class CreateCollectionsLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :collections_licenses do |t|
      t.belongs_to :collection
      t.belongs_to :license

      t.timestamps
    end
  end
end
