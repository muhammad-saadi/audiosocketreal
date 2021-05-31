module ArtistValidator
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :validate_artist
  end

  private

  def validate_artist
    raise ExceptionHandler::InvalidAccess, Message.invalid_access unless current_user.artist?
  end
end
