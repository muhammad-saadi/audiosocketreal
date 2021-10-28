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
  before_validation :order_limit, on: :update
  after_destroy :update_order

  scope :decrement_list, -> (order) { where("curated_playlists.order > ?", order) }

  def shift_below_order
     CuratedPlaylist.where("curated_playlists.order >= ? and curated_playlists.order <= ?", order, order_was).where.not(id: self.id)
  end

  def shift_above_order
     CuratedPlaylist.where("curated_playlists.order <= ? and curated_playlists.order >= ? ", order, order_was).where.not(id: self.id)
  end

  def set_order
    self.order = CuratedPlaylist.maximum('order').to_i + 1
  end

  def update_order
    decrement_list = CuratedPlaylist.decrement_list(self.order)
    CuratedPlaylist.decrement_counter(:order, decrement_list)
  end

  def order_limit
    return errors.add(:order, 'Order out of bounds') if order > CuratedPlaylist.maximum('order').to_i
    return if order_was == order
    return CuratedPlaylist.increment_counter(:order, shift_below_order) if order_was > order

    CuratedPlaylist.decrement_counter(:order, shift_above_order)
  end
end
