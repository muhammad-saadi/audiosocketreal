class AddRoleToUsersAgreement < ActiveRecord::Migration[6.1]
  def change
    add_column :users_agreements, :role, :string
  end
end
