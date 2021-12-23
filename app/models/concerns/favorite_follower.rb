module FavoriteFollower
  extend ActiveSupport::Concern

  included do
    has_many :favorite_follows, as: :favorite_follower, dependent: :destroy
  end

  def favorite!(favoritable)
    FavoriteFollow.favorite_follow!(self, favoritable, 'favorite')
  end

  def follow!(followable)
    FavoriteFollow.favorite_follow!(self, followable, 'follow')
  end

  def unfavorite!(favoritable)
    FavoriteFollow.favorite_unfollow!(self, favoritable, 'favorite')
  end

  def unfollow!(followable)
    FavoriteFollow.favorite_unfollow!(self, followable, 'follow')
  end

  def favorite_followables(klass, kind)
    FavoriteFollow.favorite_followables(self, klass, kind)
  end
end
