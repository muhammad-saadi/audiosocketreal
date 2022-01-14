class UpdateDefaultPublisherForAllUserArtists < ActiveRecord::Migration[6.1]
  def up
    @publisher = Publisher.find_by(name: DEFAULT_PUBLISHER_NAME)
    @publisher.update_attribute(:default_publisher, true)
  end

  def down
    @publisher = Publisher.find_by(name: DEFAULT_PUBLISHER_NAME)
    @publisher.update_attribute(:default_publisher, false)
  end
end
