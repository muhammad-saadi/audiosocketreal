class Collection < ApplicationRecord
  has_and_belongs_to_many :licenses
  has_and_belongs_to_many :tracks
end
