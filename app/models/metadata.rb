class Metadata < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
