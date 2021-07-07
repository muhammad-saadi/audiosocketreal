module ApplicationHelper
  def formatted_datetime(date)
    date.strftime('%B %m, %Y %R') rescue nil
  end

  def formatted_date(date)
    date.strftime('%B %m, %Y') rescue nil
  end

  def formatted_boolean(value)
    return 'no' if value.blank?

    'yes'
  end
end
