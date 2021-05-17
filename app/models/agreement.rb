class Agreement < ApplicationRecord
  has_many :users_agreements, dependent: :destroy
  has_many :users, through: :users_agreements

  has_one_attached :attachment

  TYPES = {
    exclusive: 'exclusive',
    non_exclusive: 'non_exlusive',
    youtube_content: 'youtube_content'
  }.freeze

  enum agreement_type: TYPES

  scope :exclusive, -> { where(agreement_type: [TYPES[:youtube_content], TYPES[:exclusive]]) }
  scope :non_exclusive, -> { where(agreement_type: [TYPES[:youtube_content], TYPES[:non_exclusive]]) }
end
