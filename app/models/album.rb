class Album < ApplicationRecord
  include Pagination

  belongs_to :user

  has_many :tracks, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  has_one_attached :artwork

  validates :name, presence: true
  validates :artwork, blob: { content_type: :image }, dimension: { width: 353, height: 353, message: 'must be 353x353' }
end
