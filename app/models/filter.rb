class Filter < ApplicationRecord
  validates :name, presence: true

  has_many :filters, dependent: :destroy
  belongs_to :filter, class_name: 'Filter', optional: true
end
