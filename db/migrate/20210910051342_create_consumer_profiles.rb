class CreateConsumerProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :consumer_profiles do |t|
      t.string :phone
      t.string :organization
      t.string :address
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :youtube_url
      t.boolean :white_listing_enabled, default: false

      t.references :consumer

      t.timestamps
    end
  end
end
