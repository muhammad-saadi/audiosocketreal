class CollaboratorProfile < ApplicationRecord
  belongs_to :artists_collaborator

  validates :pro, presence: true
  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true

  before_save :reset_ipi
end
