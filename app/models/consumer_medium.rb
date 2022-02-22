class ConsumerMedium < ApplicationRecord
  belongs_to :mediable, polymorphic: true
  belongs_to :consumer

  scope :downloaded_media, ->(id, type) { where(consumer_id: id, mediable_type: type) }

  def self.download_media(id, current_consumer, type)
    consumer_medium = current_consumer.consumer_media.find_by(mediable_id: id, mediable_type: type)

    if consumer_medium.present?
      consumer_medium.updated_at = Time.zone.now
    else
      consumer_medium = current_consumer.consumer_media.build(mediable_id: id, mediable_type: type )
    end

    consumer_medium
  end
end
