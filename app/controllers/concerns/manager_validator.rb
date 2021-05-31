module ManagerValidator
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :validate_manager
  end

  private

  def validate_manager
    raise ExceptionHandler::InvalidAccess, Message.invalid_access unless current_user.manager?
  end
end
