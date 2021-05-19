class Track < ApplicationRecord
  validates :title, presence: true

  belongs_to :album

  has_one_attached :file
end
