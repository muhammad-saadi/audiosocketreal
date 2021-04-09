class AuthenticateUser
  attr_accessor :email, :password

  TOKEN_EXPIRATION = 24.hours.from_now.freeze

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
  end

  def call
    raise ExceptionHandler::AuthenticationError, 'Invalid Credentials' if user.blank?

    JsonWebToken.encode({ user_id: user.id }, TOKEN_EXPIRATION)
  end

  def user
    @user ||= User.authenticate(email, password)
  end
end
