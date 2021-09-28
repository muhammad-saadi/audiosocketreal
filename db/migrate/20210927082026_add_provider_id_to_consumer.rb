class AddProviderIdToConsumer < ActiveRecord::Migration[6.1]
  def change
    add_column :consumers, :google_id, :string
    add_column :consumers, :facebook_id, :string
    add_column :consumers, :linkedin_id, :string
  end
end
