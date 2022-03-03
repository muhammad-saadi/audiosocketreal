class PlaylistTrack < ApplicationRecord
  belongs_to :mediable, polymorphic: true
  belongs_to :listable, polymorphic: true
  validates_uniqueness_of :mediable_id, scope: %i[mediable_type listable_id listable_type]
  validates_uniqueness_of :order, scope: [:listable_id]

  before_validation :create_order, on: :create

  def create_order
    self.order = PlaylistTrack.where(listable_id: listable_id, listable_type: listable_type).maximum('order').to_i + 1
  end
end