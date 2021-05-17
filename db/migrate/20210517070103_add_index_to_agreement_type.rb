class AddIndexToAgreementType < ActiveRecord::Migration[6.1]
  def change
    add_index :agreements, :agreement_type
  end
end
