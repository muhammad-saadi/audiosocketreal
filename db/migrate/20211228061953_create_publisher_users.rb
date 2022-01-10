class CreatePublisherUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :publisher_users do |t|
      t.belongs_to :publisher
      t.belongs_to :user
      t.string :pro
      t.string :ipi

      t.timestamps
    end
  end
end
