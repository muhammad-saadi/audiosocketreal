module CollaboratorValidator
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :validate_collaborator
  end

  private

  def validate_collaborator
    raise ExceptionHandler::InvalidAccess, Message.invalid_access unless current_user.collaborator?
  end
end
