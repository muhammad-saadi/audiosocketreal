class OmniauthLogin
  def self.google_client
    @client = OAuth2::Client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
                                   authorize_url: 'https://accounts.google.com/o/oauth2/auth',
                                   token_url: 'https://accounts.google.com/o/oauth2/token'
                                 })
    end

  def self.facebook_client
    @client = OAuth2::Client.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], {
                                   site: 'https://graph.facebook.com/v7.0',
                                   authorize_url: 'https://www.facebook.com/v7.0/dialog/oauth',
                                   token_url: '/oauth/access_token'
                                 })
  end

  def self.google_url
    google_client.auth_code.authorize_url({
                                            scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile',
                                            redirect_uri: ENV['FRONTEND_GOOGLE_CALLBACK'],
                                            access_type: 'offline',
                                            prompt: 'consent'
                                          })
  end

  def self.facebook_url
    facebook_client.auth_code.authorize_url({
                                              scope: 'email public_profile',
                                              redirect_uri: ENV['FRONTEND_FACEBOOK_CALLBACK'],
                                              access_type: 'offline',
                                              prompt: 'consent'
                                            })
  end

  def self.google_callback_response(code)
    access_token = google_client.auth_code.get_token(code, redirect_uri: ENV['FRONTEND_GOOGLE_CALLBACK'])
    response = HTTParty.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json', headers: { Authorization: "Bearer #{access_token.token}" }).parsed_response
    consumer = Consumer.find_or_initialize_by(email: response['email'])

    if consumer.new_record?
      consumer.assign_attributes(first_name: response['given_name'], last_name: response['family_name'])
      consumer.skip_password_validation = true
      consumer.save!
    end
    consumer.encoded_id
  end

  def self.facebook_callback_response(code)
    access_token = facebook_client.auth_code.get_token(code, redirect_uri: ENV['FRONTEND_FACEBOOK_CALLBACK'])
    response = HTTParty.get("https://graph.facebook.com/me?fields=id, first_name, last_name, email&access_token=#{access_token.token}").parsed_response
    consumer = Consumer.find_or_initialize_by(email: response['email']) || Consumer.find_or_initialize_by(provider_id: response['id'])

    if consumer.new_record?
      consumer.assign_attributes(email: response['email'], first_name: response['first_name'], last_name: response['last_name'])
      consumer.skip_password_validation = true
      consumer.save!
    end
    consumer.encoded_id
  end
end
