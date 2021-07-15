class TrackFilter < ApplicationRecord
  belongs_to :filter
  belongs_to :track
end
