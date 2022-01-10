class RemoveIpAndProFromPublisher < ActiveRecord::Migration[6.1]

  def up
    Publisher.all.each do |p|
      PublisherUsers.create(publisher_id: p.id, user_id: p.user_id, pro: p.pro, ipi: p.ipi)
    end
    Publisher.create(name: 'AudioSocket')

    remove_column :publishers, :ipi
    remove_column :publishers, :pro
    remove_column :publishers, :user_id
  end

  def down
    add_column :publishers, :ipi, :string
    add_column :publishers, :pro, :string
    add_reference :user

    Publisher.all.each do |p|
      publisherUser = PublisherUsers.where(publisher_id: p.id)
      bool = false

      publisherUser.each do |pu|
        if bool == false
          p.update(ipi: pu.ipi, pro: pu.pro, user_id: pu.user_id)
          bool = true
        else
          Publisher.create(name: pu.name, pro: pu.pro, ipi: pu.ipi, user_id: pu.user_id)
        end
      end
    end
  end

end
