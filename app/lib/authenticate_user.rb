class AuthenticateUser
  attr_accessor :email, :password, :remember_me

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
    @remember_me = params[:remember_me]
  end

  def call
    raise ExceptionHandler::AuthenticationError, 'Invalid Credentials' if user.blank?

    return JsonWebToken.encode({ user_id: user.id }, 1.year.from_now) if remember_me?

    JsonWebToken.encode({ user_id: user.id }, 24.hours.from_now)
  end

  def user
    @user ||= User.authenticate(email, password)
  end

  def remember_me?
    return true if remember_me == 'true' || remember_me == true
    false
  end
end
