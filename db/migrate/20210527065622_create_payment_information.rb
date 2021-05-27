class CreatePaymentInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_informations do |t|
      t.string :payee_name
      t.string :bank_name
      t.string :routing
      t.string :account_number
      t.string :paypal_email

      t.references :artist_profile
      t.timestamps
    end
  end
end
