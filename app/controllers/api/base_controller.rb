class Api::BaseController < ActionController::API
  include ExceptionHandler
  include RolesValidator

  attr_reader :current_user

  before_action :authorize_request
  before_action :authenticate_user!

  skip_before_action :authenticate_user!, only: :route_not_found

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def route_not_found
    render json: { error: 'Invalid Access' }, status: :not_found
  end

  def response_msg(status, message)
    render json: { status: status, message: message }
  end

  private

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound => e
    five_hundred_standard(e)
  end

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

  def parameter_missing(exception)
    render json: { error: exception.message, code: :parameter_missing, status: 500 }, status: 500
  end

  def authenticate_user!
    @current_user = AuthorizeUser.new(request.headers['auth-token']).call
    set_current_user
  end

  def wrap_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def set_current_user
    Current.user = current_user
  end

  def pagination_params
    params.permit(:pagination, :page, :per_page)
  end
end
