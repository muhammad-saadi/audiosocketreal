class RemoveDefaultPublisherFromPublishers < ActiveRecord::Migration[6.1]
  def change
    remove_column :publishers, :default_publisher
  end
end
