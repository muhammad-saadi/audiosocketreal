class AddProviderIdToConsumer < ActiveRecord::Migration[6.1]
  def change
    add_column :consumers, :provider_id, :string
  end
end
