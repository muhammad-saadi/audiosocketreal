class AuditionMusic < ApplicationRecord
  belongs_to :audition

  validates :track_link, presence: true
end
