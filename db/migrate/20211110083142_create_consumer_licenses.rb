class CreateConsumerLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :consumer_licenses do |t|
      t.text :consumer_license_html
      t.float :consumer_price
      t.integer :track_id
      t.references :consumer
      t.references :license
      
      t.timestamps
    end
  end
end
