class CreateDefaultPublisherForAllUserArtists < ActiveRecord::Migration[6.1]
  def up
    Publisher.create!(name: DEFAULT_PUBLISHER_NAME)
  end

  def down
    Publisher.find_by(name: DEFAULT_PUBLISHER_NAME).destroy!
  end
end
