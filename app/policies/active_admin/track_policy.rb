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

  def destroy_all?
    @user.admin?
  end 
end
