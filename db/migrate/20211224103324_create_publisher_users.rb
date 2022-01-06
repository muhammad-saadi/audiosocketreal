class CreatePublisherUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :publisher_users do |t|
      t.string :pro
      t.string :ipi
      t.references :publisher
      t.references :user

      t.timestamps
    end
  end
end
