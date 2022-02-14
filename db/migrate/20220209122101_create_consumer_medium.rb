class CreateConsumerMedium < ActiveRecord::Migration[6.1]
  def change
    create_table :consumer_media do |t|
      t.references :consumer
      t.references :mediable, polymorphic: true

      t.timestamps
    end
  end
end
