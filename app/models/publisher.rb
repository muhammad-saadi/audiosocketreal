class Publisher < ApplicationRecord
  include Pagination

  has_many :track_publishers
  has_many :tracks, through: :track_publishers, dependent: :restrict_with_exception
  has_many :publisher_users, dependent: :destroy
  has_many :users, through: :publisher_users

  accepts_nested_attributes_for :publisher_users, allow_destroy: true

  validates :name, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :ordered_by_pro, -> { order(Arel.sql("(case when  pro ILIKE 'us%' then 1 else 0 end) DESC, pro")) }
end
