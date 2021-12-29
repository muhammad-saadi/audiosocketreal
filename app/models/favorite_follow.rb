class FavoriteFollow < ApplicationRecord
  belongs_to :favorite_followable, polymorphic: true
  belongs_to :favorite_follower, polymorphic: true

  validates :favorite_followable_id, uniqueness: { scope: %i[favorite_follower_type kind favorite_followable_type favorite_follower_id ], message: "has been already taken" }
  validate :follow_playlist_validation

  def self.human_attribute_name(attr, options = {})
   options[:base][:favorite_followable_type]
  end

  def self.favorite_follow!(follower, followable, kind)
    self.create!(favorite_follower: follower, favorite_followable: followable, kind: kind)
  end

  def self.favorite_unfollow!(follower, followable, kind)
    self.find_by(favorite_follower: follower, favorite_followable: followable, kind: kind)&.destroy
  end

  def self.favorite_followables(follower, klass, kind)
    klass.constantize.where(id: self.select(:favorite_followable_id)
    .where(favorite_followable_type: klass)
    .where(favorite_follower_type: follower.class.to_s)
    .where(favorite_follower_id: follower.id)
    .where(kind: kind))
  end

  def follow_playlist_validation
    errors.add(:playlist, 'can not follow their own playlist.') if favorite_followable_type == 'ConsumerPlaylist' && favorite_follower == favorite_followable.consumer && kind == 'follow'
  end
end
