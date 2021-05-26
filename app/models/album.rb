class Album < ApplicationRecord
  belongs_to :user

  has_many :tracks, dependent: :destroy

  has_one_attached :artwork

  validates :name, presence: true
  validates :artwork, blob: { content_type: :image }
end
