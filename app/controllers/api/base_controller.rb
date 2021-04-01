class Api::BaseController < ActionController::API
  include ExceptionHandler

  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  protected

  def render_unauthorized(message)
    render json: { message: message }, status: :unauthorized
  end

  def authorized?
    @authorized
  end

  private

  def authorize_request
    @authorized = AuthorizeApiRequest.new(request.headers).call[:result]
  end

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def record_not_unique(exception)
    render json: { code: :record_not_unique, message: exception.cause, status: 400 }, status: :bad_request
  end

  def invalid_request(exception)
    render json: { error: exception.message, code: :not_acceptable, status: 406 }, status: :not_acceptable
  end
end
