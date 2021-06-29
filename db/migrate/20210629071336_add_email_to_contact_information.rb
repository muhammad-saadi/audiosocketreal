class AddEmailToContactInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_informations, :email, :string
  end
end
