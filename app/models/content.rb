class Content < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
