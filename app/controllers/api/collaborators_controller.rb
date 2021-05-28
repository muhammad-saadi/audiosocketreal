class Api::CollaboratorsController < Api::BaseController
  before_action :authenticate_user!
  before_action :validate_role

  private

  def validate_role
    raise ExceptionHandler::InvalidAccess, 'Not accessible. User must be artist' unless current_user.collaborator?
  end
end
