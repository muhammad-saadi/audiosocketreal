class Filter < ApplicationRecord
  validates :title, presence: true

  has_many :sub_filters, dependent: :destroy
end
