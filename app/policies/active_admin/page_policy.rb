class ActiveAdmin::PagePolicy < ApplicationPolicy
  def show?
    case record.name
    when "Dashboard"
      true
    else
      false
    end
  end
end
