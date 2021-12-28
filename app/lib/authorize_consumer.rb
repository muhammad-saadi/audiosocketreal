class AuthorizeConsumer
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def call
    consumer
  end

  def consumer
    @consumer ||= Consumer.find(JsonWebToken.decode(token)[:consumer_id])
  end
end
