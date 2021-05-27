class CreateTaxInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :tax_informations do |t|
      t.string :ssn

      t.references :artist_profile
      t.timestamps
    end
  end
end
