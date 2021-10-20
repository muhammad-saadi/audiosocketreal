class RequestLimit < ApplicationRecord
  belongs_to :limitable, polymorphic: true

  before_create :set_data

  validates_uniqueness_of :request_type, scope: %i[limitable_id limitable_type]

  def increment_usage(max_limit: 100)
    reset_usage if last_used != Date.today
    raise ExceptionHandler::LimitError.new("#{request_type.humanize} limit for the day reached") if daily_limit_reached?(max_limit: max_limit)

    increment!(:daily_usage)
  end

  def daily_limit_reached?(max_limit: 100)
    daily_usage >= max_limit
  end

  private

  def set_data
    self.daily_usage = 0
    self.last_used = Date.today
  end

  def reset_usage
    update_columns(daily_usage: 0, last_used: Date.today)
  end
end
