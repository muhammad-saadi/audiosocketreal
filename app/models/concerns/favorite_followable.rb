module FavoriteFollowable
  extend ActiveSupport::Concern

  def favorite_followers(klass, kind)
    FavoriteFollow.favorite_followers(self, klass, kind)
  end
end
