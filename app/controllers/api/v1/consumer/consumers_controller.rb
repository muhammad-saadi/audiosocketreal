class Api::V1::Consumer::ConsumersController < Api::V1::Consumer::BaseController
  before_action :validate_password, only: %i[update_email update_password]

  def show_profile
    render json: current_consumer
  end

  def update_email
    if current_consumer.update(email: params[:email])
      render json: current_consumer
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating email.')
    end
  end

  def update_password
    if current_consumer.update(password_params)
      render json: current_consumer, meta: { status: :successful }, adapter: :json
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating password.')
    end
  end

  def update_profile
    if current_consumer.update(consumer_profile_params)
      render json: current_consumer
    else
      raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Error updating profile.')
    end
  end

  private

  def validate_password
    return if current_consumer&.valid_password?(params[:current_password])

    raise ExceptionHandler::ValidationError.new(current_consumer.errors.to_h, 'Wrong Password')
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def consumer_profile_params
    params.permit(:first_name, :last_name, :email, consumer_profile_attributes: %i[id phone organization address city country
                                                                                   postal_code youtube_url white_listing_enabled])
  end
end
