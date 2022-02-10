class Api::V1::Consumer::BaseController < Api::BaseController
  skip_before_action :authenticate_user!
  before_action :set_current_consumer
  before_action :authenticate_consumer!

  attr_reader :current_consumer

  private

  def set_current_consumer
    @current_consumer = AuthorizeConsumer.new(request.headers['auth-token']).call if request.headers['auth-token'].present?
  end

  def authenticate_consumer!
    raise ExceptionHandler::MissingToken, Message.missing_token if current_consumer.blank?
  end
end
