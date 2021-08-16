class ActiveAdmin::UserPolicy < ApplicationPolicy
  def index?
    @user.admin? || @user.accountant?
  end

  def show?
    @user.admin? || (@record.artist? && @user.accountant?)
  end

  def create?
    @user.admin?
  end

  def update?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end
  
  def destroy_all?
    @user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.artist if @user.accountant?

      scope.all
    end
  end
end
