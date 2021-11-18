module FavoriteFollowable
  extend ActiveSupport::Concern

  included do
    has_many :favorite_follows, as: :favorite_followable, dependent: :destroy
  end

  def favorite_followers(klass, kind)
    FavoriteFollow.favorite_followers(self, klass, kind)
  end
end
