class JsonWebToken
  HMAC_SECRET = ENV['SECRET_KEY_BASE']

  class << self
    def encode(payload)
      JWT.encode(payload, HMAC_SECRET)
    end

    def decode(token)
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end

    def generate_token
      encode({ app_id: ENV['APP_ID'] })
    end
  end
end
