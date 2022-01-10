class AddDefaultPublisherToArtist < ActiveRecord::Migration[6.1]
  def up
    publisher = Publisher.find_by(name: 'AudioSocket')
    User.artist.each do |user|
      PublisherUser.create(publisher_id: publisher.id, user_id: user.id)
    end
  end

  def down
    publisher = Publisher.find_by(name: 'AudioSocket')
    PublisherUser.where(publisher_id: publisher.id).each do |publisher_user|
      publisher_user.delete
    end
  end
end
