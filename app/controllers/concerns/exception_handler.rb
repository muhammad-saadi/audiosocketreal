module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end

  class MissingToken < StandardError; end

  class InvalidToken < StandardError; end

  class InvalidAccess < StandardError; end

  class ArgumentError < StandardError; end

  class TaxFormError < StandardError; end

  class LimitError < StandardError; end

  class AuthorizationError < StandardError; end

  class TokenError < StandardError
    attr_reader :message

    def initialize(message)
     super(message)
     @message = message
    end
  end

  class ValidationError < StandardError
    attr_reader :errors, :message

    def initialize(errors, message)
      super(message)
      @errors = errors
      @message = message
    end
  end

  class OAuth2::Error < StandardError
    attr_reader :message

    def initialize(response)
      super(response)
      @message = JSON.parse(response.body)
      @message = @message['error_description'] || @message['error']['message']
    end
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from AuthenticationError, with: :unauthorized_request
    rescue_from MissingToken, with: :four_twenty_two
    rescue_from InvalidToken, with: :four_twenty_two
    rescue_from ValidationError, with: :five_hundred
    rescue_from ArgumentError, with: :five_hundred_standard
    rescue_from TokenError, with: :five_hundred_standard
    rescue_from InvalidAccess, with: :four_zero_three
    rescue_from ActiveRecord::DeleteRestrictionError, with: :four_hundred
    rescue_from TaxFormError, with: :four_twenty_two
    rescue_from OAuth2::Error, with: :five_hundred_standard
    rescue_from LimitError, with: :unauthorized_request
    rescue_from AuthorizationError, with: :five_hundred_special

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    render json: { message: e.message }, status: :unauthorized
  end

  # JSON response with message; Status code 500 - Internal server error
  def five_hundred(e)
    render json: { errors: e.errors, message: e.message }, status: :internal_server_error
  end

  # JSON response with message; Status code 500 - Internal server error
  def five_hundred_standard(e)
    render json: { message: e.message }, status: :internal_server_error
  end

  # JSON response with message; Status code 403 - Forbidden
  def four_zero_three(e)
    render json: { message: e.message }, status: :forbidden
  end

  # JSON response with message; Status code 400 - Bad Request
  def four_hundred(e)
    render json: { message: e.message }, status: :bad_request
  end

  def five_hundred_special(e)
    render json: { errors: e.message }, status: :internal_server_error
  end
end
