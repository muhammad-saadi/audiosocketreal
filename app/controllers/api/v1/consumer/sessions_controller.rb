class Api::V1::Consumer::SessionsController < Api::V1::Consumer::BaseController
  skip_before_action :authenticate_consumer!

  def signup
    @consumer = Consumer.new(signup_params)

    if @consumer.save
      consumer_success_response
    else
      raise ExceptionHandler::ValidationError.new(@consumer.errors.to_h, 'Error creating consumer.')
    end
  end

  def create
    @consumer = Consumer.find(JsonWebToken.decode(auth_token)[:consumer_id])

    consumer_success_response
  end

  private

  def auth_token
    AuthenticateConsumer.new(authentication_params).call
  end

  def signup_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation, :content_type)
  end

  def authentication_params
    params.permit(:email, :password, :remember_me)
  end

  def consumer_success_response
    render json: { auth_token: auth_token, first_name: @consumer.first_name, last_name: @consumer.last_name, email: @consumer.email }
  end
end
