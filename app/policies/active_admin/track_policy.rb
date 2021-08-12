class ActiveAdmin::TrackPolicy < ApplicationPolicy
  def index?
    @user.admin?
  end

  def show?
    @user.admin?
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

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
