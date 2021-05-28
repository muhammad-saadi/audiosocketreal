class Api::ArtistsController < Api::BaseController
  before_action :authenticate_user!
  before_action :validate_role

  private

  def validate_role
    raise ExceptionHandler::InvalidAccess, 'Not accessible. User must be artist' unless current_user.artist?
  end
end
