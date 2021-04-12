module ApplicationHelper
  def formatted_date(date)
    date.strftime('%d-%m-%Y') rescue nil
  end
end
