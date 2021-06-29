class CollaboratorProfile < ApplicationRecord
  belongs_to :artists_collaborator

  validates :ipi, numericality: true, length: { is: 9 }
end
