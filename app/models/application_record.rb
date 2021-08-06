class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  def reset_ipi
    self.ipi = nil if pro == 'NS'
  end
end
