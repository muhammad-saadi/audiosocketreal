class AddSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :licenses, :subscription, :string
    add_column :consumers, :subscription_type, :string
  end
end
