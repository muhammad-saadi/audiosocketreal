class RemoveSsnFromTaxInformations < ActiveRecord::Migration[6.1]
  def change
    remove_column :tax_informations, :ssn, :string
  end
end
