class CollaboratorProfile < ApplicationRecord
  belongs_to :artists_collaborator

  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { is: 9 }, allow_blank: true
end
