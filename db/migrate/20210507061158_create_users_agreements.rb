class CreateUsersAgreements < ActiveRecord::Migration[6.1]
  def change
    create_table :users_agreements do |t|
      t.references :user
      t.references :agreement
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
