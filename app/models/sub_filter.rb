class SubFilter < ApplicationRecord
  validates :name, presence: true

  has_many :sub_filters, dependent: :destroy
  belongs_to :sub_filter, class_name: 'SubFilter', optional: true
  belongs_to :filter
end
