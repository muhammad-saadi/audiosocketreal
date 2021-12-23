class AddDefaultPublisherToPublishers < ActiveRecord::Migration[6.1]
  def change
    add_column :publishers, :default_publisher, :boolean, default: false
  end
end
