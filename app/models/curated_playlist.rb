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

  before_validation :set_order, on: :create
  before_validation :shift_order, on: :update
  after_destroy :decrement_orders

  scope :above_order, -> (order) { where("curated_playlists.order > ?", order) }
  scope :items_between, -> (order1, order2) { where("curated_playlists.order >= ? and curated_playlists.order <= ?", order1, order2) }
  scope :exclude, -> (id) { where.not(id: id) }

  def max_order
    CuratedPlaylist.maximum('order').to_i
  end

  def set_order
    self.order = max_order + 1
  end

  def decrement_orders
    CuratedPlaylist.decrement_counter(:order, CuratedPlaylist.above_order(self.order))
  end

  def shift_order
    return errors.add(:order, 'Order out of bounds') if order > max_order
    return if order_was == order
    return CuratedPlaylist.increment_counter(:order, CuratedPlaylist.items_between(order, order_was).exclude(id)) if order_was > order

    CuratedPlaylist.decrement_counter(:order, CuratedPlaylist.items_between(order_was, order).exclude(id))
  end
end
