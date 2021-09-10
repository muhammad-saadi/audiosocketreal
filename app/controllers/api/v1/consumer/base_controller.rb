class Api::V1::Consumer::BaseController < Api::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_consumer!

  attr_reader :current_consumer

  private

  def authenticate_consumer!
    @current_consumer = AuthorizeConsumer.new(request.headers['auth-token']).call
  end
end
