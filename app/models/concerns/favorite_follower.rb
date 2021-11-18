module FavoriteFollower
  extend ActiveSupport::Concern

  included do
    has_many :favorite_follows, as: :favorite_follower, dependent: :destroy
  end

  def favorite_follow!(followable, kind)
    FavoriteFollow.favorite_follow!(self, followable, kind)
  end

  def favorite_unfollow!(followable, kind)
    FavoriteFollow.favorite_unfollow!(self, followable, kind)
  end

  def favorite_followables(klass, kind)
    FavoriteFollow.favorite_followables(self, klass, kind)
  end
end
