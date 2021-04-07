class AuditionsGenre < ApplicationRecord
  belongs_to :audition
  belongs_to :genre
end
