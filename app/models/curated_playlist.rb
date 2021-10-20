class CuratedPlaylist < ApplicationRecord
  has_many :playlist_tracks, as: :listable
  has_many :tracks, through: :playlist_tracks, dependent: :destroy

  has_one_attached :playlist_image
  has_one_attached :banner_image

  validates :playlist_image, dimension: { min: 353..353, message: 'must be minimum 353x353' }
  validates :banner_image, dimension: { min: 1440..448, message: 'must be minimum 1440x448' }
  validates :order, numericality: { greater_than_or_equal_to: 1 }
  validates_uniqueness_of :order

  accepts_nested_attributes_for :playlist_tracks, allow_destroy: true

  before_validation :create_order, on: :create
  before_validation :order_limit, on: :update
  after_destroy :set_order

  scope :delete_order, -> (order) { where("curated_playlists.order > ?", order) }
  scope :below_order, ->(order, order_was) { where("curated_playlists.order >= ? and curated_playlists.order <= ?", order, order_was) }
  scope :above_order, ->(order, order_was) { where("curated_playlists.order <= ? and curated_playlists.order >= ? ", order, order_was) }

  def create_order
    self.order = CuratedPlaylist.maximum('order').to_i + 1
  end

  def set_order
    delete_order = CuratedPlaylist.delete_order(self.order)
    CuratedPlaylist.decrement_counter(:order, delete_order)
  end

  def order_limit
    errors.add(:order, 'Order out of bounds') if order > CuratedPlaylist.maximum('order').to_i
    if order_was > order
      below_order = CuratedPlaylist.below_order(order, order_was).without(self)
      CuratedPlaylist.increment_counter(:order, below_order)
    elsif order_was < order
      above_order = CuratedPlaylist.above_order(order, order_was).without(self)
      CuratedPlaylist.decrement_counter(:order, above_order)
    end
  end
end
