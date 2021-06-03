class AddPhoneToContactInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_informations, :phone, :string
  end
end
