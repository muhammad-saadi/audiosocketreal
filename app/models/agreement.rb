class Agreement < ApplicationRecord
  has_many :users_agreements
  has_many :users, through: :users_agreements

  has_one_attached :attachment
end
