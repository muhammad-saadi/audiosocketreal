module ApplicationHelper
  def formatted_date(date)
    date.strftime('%d-%m-%Y %r') rescue nil
  end
end
