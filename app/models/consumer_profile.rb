class ConsumerProfile < ApplicationRecord
  belongs_to :consumer

  validates_presence_of :country
  validates_presence_of :youtube_url, if: -> { white_listing_enabled? }
end
