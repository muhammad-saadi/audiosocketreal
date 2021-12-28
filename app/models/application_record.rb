class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_created_at
    created_at.localtime.strftime('%B %d, %Y %R')
  end

  def formatted_updated_at
    updated_at.localtime.strftime('%B %d, %Y %R')
  end

  protected

  def reset_ipi
    self.ipi = nil if pro == 'NS'
  end

  def self.filter(key, query)
    ransack("#{key}_cont": query).result
  end
end
