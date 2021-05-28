class Publisher < ApplicationRecord
  belongs_to :user

  has_many :tracks

  scope :ordered, -> { order(created_at: :desc) }
end
