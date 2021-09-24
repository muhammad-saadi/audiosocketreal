class Api::V1::Consumer::SessionsController < Api::V1::Consumer::BaseController
  skip_before_action :authenticate_consumer!

  def signup
    @consumer = Consumer.new(signup_params)
    if @consumer.save
      render json: { auth_token: auth_token}
    else
      raise ExceptionHandler::ValidationError.new(@consumer.errors.to_h, 'Error creating consumer.')
    end
  end

  def create
    render json: { auth_token: auth_token }
  end

  def google_callback
    code = params[:code]
    render json: { auth_token: OmniauthLogin.google_callback_response(code) }
  end

  def google_auth
    render json: { url: OmniauthLogin.google_url }
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
end
