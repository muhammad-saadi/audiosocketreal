class TrackPublisher < ApplicationRecord
  belongs_to :publisher
  belongs_to :track

  validates_presence_of :track, :publisher
  validates_uniqueness_of :publisher_id, scope: [:track_id]

  def publisher_name
    publisher.name
  end
end
