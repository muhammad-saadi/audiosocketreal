class Api::V1::Collaborator::BaseController < Api::BaseController
  include AccessValidator

  validate_role roles: ['collaborator']

  before_action :set_current_artist

  private

  def set_current_artist
    unless (@current_artist = current_user.artists.find_by(id: params[:artist_id]))
      raise ExceptionHandler::InvalidAccess, Message.invalid_access
    end
  end
end
