class AddTaxIdTaxInformation < ActiveRecord::Migration[6.1]
  def change
    add_column :tax_informations, :tax_id, :string
  end
end
