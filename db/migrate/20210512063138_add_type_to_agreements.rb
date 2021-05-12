class AddTypeToAgreements < ActiveRecord::Migration[6.1]
  def change
    add_column :agreements, :agreement_type, :string
  end
end
