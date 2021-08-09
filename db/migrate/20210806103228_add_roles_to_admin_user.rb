class AddRolesToAdminUser < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :roles, :text, array: true, default: []
  end
end
