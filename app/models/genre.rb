class Genre < ApplicationRecord
  validates :name, presence: true

  has_many :auditions_genres, dependent: :destroy
  has_many :auditions, through: :auditions_genres
end
