class RemoveColumnsFromPublishers < ActiveRecord::Migration[6.1]
  def up
    Publisher.find_each do |pub|
      pub.update(name: pub.name.delete(' ').upcase)
      PublisherUser.create!(publisher_id: pub.id, user_id: pub.user_id, ipi: pub.ipi || '123456789', pro: pub.pro || '-')
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
      current_record = Publisher.find_by(id: pubu.publisher_id)
      if current_record.ipi.blank? && current_record.pro.blank?
        current_record.update_columns(user_id: pubu.user_id, ipi: pubu.ipi, pro: pubu.pro)
        current_record.save!
      else
        Publisher.create!(name: current_record.name, user_id: pubu.user_id, ipi: pubu.ipi, pro: pubu.pro)
      end
    end

    PublisherUser.destroy_all
  end
end
