module FavoriteFollowable
  extend ActiveSupport::Concern

  included do
    has_many :favorite_follows, as: :favorite_followable, dependent: :destroy
  end

  def is_favoritable?
    true
  end

  def is_followable?
    true
  end
end