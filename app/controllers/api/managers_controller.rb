class Api::ManagersController < Api::BaseController
  before_action :authenticate_user!
  before_action :validate_role

  private

  def validate_role
    raise ExceptionHandler::InvalidAccess, Message.invalid_access unless current_user.manager?
  end
end
