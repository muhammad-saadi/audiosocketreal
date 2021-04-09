class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    {
      result: validate_token
    }
  end

  private

  attr_reader :headers

  def validate_token
    return true if decoded_auth_token && decoded_auth_token[:app_id] == ENV['APP_ID']

    raise ExceptionHandler::InvalidToken, Message.invalid_token
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    return headers['Authorization'] if headers['Authorization'].present?

    raise ExceptionHandler::MissingToken, Message.missing_token
  end
end
