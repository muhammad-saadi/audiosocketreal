class ActiveAdmin::ContactInformationPolicy < ApplicationPolicy
  def index?
    @user.admin? || @user.accountant?
  end

  def show?
    @user.admin? || @user.accountant?
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
end
