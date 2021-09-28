class Api::V1::Consumer::OauthController < Api::V1::Consumer::BaseController
  skip_before_action :authenticate_consumer!

  def google_callback
    code = params[:code]
    render json: { auth_token: OmniauthLogin.google_callback_response(code) }
  end

  def facebook_callback
    code = params[:code]
    render json: { auth_token: OmniauthLogin.facebook_callback_response(code) }
  end

  def linkedin_callback
    code = params[:code]
    render json: { auth_token: OmniauthLogin.linkedin_callback_response(code) }
  end

  def google_login
    render json: { url: OmniauthLogin.google_url }
  end

  def facebook_login
    render json: { url: OmniauthLogin.facebook_url }
  end

  def linkedin_login
    render json: { url: OmniauthLogin.linkedin_url }
  end
end
