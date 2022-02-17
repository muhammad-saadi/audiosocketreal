class CuratedPlaylist < ApplicationRecord
  include FavoriteFollowable
  include Mediable

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

  def self.search(query)
    scope = self.all
    scope = scope.with_keywords_or_title(query) if query.present?
    scope
  end

  def self.with_keywords_or_title(query)
    query_words = query.split(' ')
    query_words << query
    query_array = query_words.flatten.uniq
    query_array = query_array.map{ |obj| "%#{obj}%" }
    self.ransack("keywords_or_name_matches_any": query_array).result(distinct: true)
  end

  def self.eagerload_columns
    { banner_image_attachment: :blob, playlist_image_attachment: :blob, tracks: [:alternate_versions, filters: [:parent_filter, sub_filters: [sub_filters: :sub_filters]], file_attachment: :blob] }
  end

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

  def self.assign_playlist_tracks(curated_playlist, consumer_playlist)
    (curated_playlist.tracks = consumer_playlist.tracks) && (curated_playlist.sfxes = consumer_playlist.sfxes)
  end
end
