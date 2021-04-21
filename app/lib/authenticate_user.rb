class AuthenticateUser
  attr_accessor :email, :password, :remember_me

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
    @remember_me = params[:remember_me]
  end

  def call
    raise ExceptionHandler::AuthenticationError, 'Invalid Credentials' if user.blank?

    expiration_time = remember_me? && 1.year.from_now || 24.hours.from_now
    JsonWebToken.encode({ user_id: user.id }, expiration_time)
  end

  def user
    @user ||= User.authenticate(email, password)
  end

  def remember_me?
    remember_me.in? [true, 'true']
  end
end
