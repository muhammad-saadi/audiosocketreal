class CreateContactInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_informations do |t|
      t.string :name
      t.string :street
      t.string :postal_code
      t.string :city
      t.string :state
      t.string :country

      t.references :artist_profile
      t.timestamps
    end
  end
end
