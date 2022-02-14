module Media
  extend ActiveSupport::Concern

  included do
    has_many :media_filters, as: :filterable, dependent: :destroy
    has_many :filters, through: :media_filters
    has_many :consumer_media, as: :mediable, dependent: :destroy
    has_many :consumers, through: :consumer_media
  end

  def filter_ids=(ids)
    transaction do
      super
      raise ActiveRecord::Rollback unless valid?
    end
  end

  def filter_count
    self.filters.size
  end
end
