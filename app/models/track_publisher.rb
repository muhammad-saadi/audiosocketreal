class TrackPublisher < ApplicationRecord
  belongs_to :publisher
  belongs_to :track

  validates_presence_of :track, :publisher, :percentage
  validates_uniqueness_of :publisher_id, scope: [:track_id]
  validates :percentage, numericality: { greater_than_or_equal_to: 0 }

  def publisher_name
    publisher&.name
  end
end
