class Filter < ApplicationRecord
  validates :name, presence: true

  has_many :sub_filters, foreign_key: 'parent_filter_id', class_name: 'Filter', dependent: :destroy
  belongs_to :parent_filter, class_name: 'Filter', optional: true

  scope :parent_filters, -> { where(parent_filter: nil) }
end
