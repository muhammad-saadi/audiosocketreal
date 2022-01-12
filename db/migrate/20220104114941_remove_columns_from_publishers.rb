class RemoveColumnsFromPublishers < ActiveRecord::Migration[6.1]
  def up
    Publisher.find_each do |pub|
      pub.update(name: pub.name.delete(' ').upcase)
      publisher = PublisherUser.new(publisher_id: pub.id, user_id: pub.user_id, ipi: pub.ipi || '123456789', pro: pub.pro || '-')
      publisher.save(validate: false)
    end

    remove_column :publishers, :user_id, :bigint
    remove_column :publishers, :pro, :string
    remove_column :publishers, :ipi, :string
  end

  def down
    add_column :publishers, :ipi, :string
    add_column :publishers, :pro, :string
    add_column :publishers, :user_id, :bigint

    PublisherUser.find_each do |pubu|
      publisher = Publisher.find_by(id: pubu.publisher_id)

      if publisher.ipi.blank? && publisher.pro.blank?
        publisher.update_columns(user_id: pubu.user_id, ipi: pubu.ipi, pro: pubu.pro)
        publisher.save!
      else
        publisher = Publisher.new(name: publisher.name, user_id: pubu.user_id, ipi: pubu.ipi, pro: pubu.pro)
        publisher.save(validate: false)
      end
    end

    PublisherUser.destroy_all
  end
end
