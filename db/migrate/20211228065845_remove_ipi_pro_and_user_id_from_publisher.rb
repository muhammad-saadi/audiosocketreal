class RemoveIpiProAndUserIdFromPublisher < ActiveRecord::Migration[6.1]

  def up
    Publisher.find_each do |p|
      PublisherUser.create(publisher_id: p.id, user_id: p.user_id, pro: p.pro, ipi: p.ipi)
    end

    remove_column :publishers, :ipi
    remove_column :publishers, :pro
    remove_column :publishers, :user_id
  end

  def down
    add_column :publishers, :ipi, :string
    add_column :publishers, :pro, :string
    add_reference :publishers, :user

    Publisher.find_each do |p|
      publisherUser = PublisherUser.where(publisher_id: p.id)
      bool = false

      publisherUser.find_each do |pu|
        if p.ipi.blank? && p.pro.blank?
          p.update(ipi: pu.ipi, pro: pu.pro, user_id: pu.user_id)
        else
          Publisher.create(name: p.name, pro: pu.pro, ipi: pu.ipi, user_id: pu.user_id)
        end
      end
    end
  end

end
