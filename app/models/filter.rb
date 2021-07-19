class Filter < ApplicationRecord
  validates :name, :max_levels_allowed, presence: true

  has_many :sub_filters, foreign_key: 'parent_filter_id', class_name: 'Filter', dependent: :destroy
  has_many :track_filters, dependent: :destroy
  has_many :tracks, through: :track_filters
  belongs_to :parent_filter, class_name: 'Filter', optional: true

  scope :parent_filters, -> { where(parent_filter: nil) }
end
