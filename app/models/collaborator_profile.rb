class CollaboratorProfile < ApplicationRecord
  belongs_to :artists_collaborator

  validates :ipi, presence: true, unless: -> { pro == 'NS' }
  validates :ipi, numericality: true, length: { minimum: 9 }, allow_blank: true

  before_save :reset_ipi

  private

  def reset_ipi
    self.ipi = nil if pro == 'NS'
  end
end
