class Filter < ApplicationRecord
  validates :name, :max_levels_allowed, presence: true
  validates :max_levels_allowed, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  has_many :sub_filters, foreign_key: 'parent_filter_id', class_name: 'Filter', dependent: :destroy
  has_many :track_filters, dependent: :destroy
  has_many :tracks, through: :track_filters
  belongs_to :parent_filter, class_name: 'Filter', optional: true

  scope :parent_filters, -> { where(parent_filter: nil) }

  MOODS = 'moods'.freeze
  GENRES = 'genres'.freeze
  INSTRUMENTS = 'instruments'.freeze
  THEMES = 'themes'.freeze

  def filter_options
    sub_filters.pluck(:name, :id)
  end

  def all_sub_filters
    sub_filters + sub_filters.map(&:sub_filters).flatten
  end

  def name_like(filter_name)
    name.downcase.include?(filter_name)
  end
end
