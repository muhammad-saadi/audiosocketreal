class Api::V1::PublishersController < Api::BaseController
  include Api::V1::Docs::PublishersDoc

  before_action :authenticate_user!

  param_group :doc_publishers
  def index
    render json: current_user.publishers
  end

  param_group :doc_create_publishers
  def create
    @publisher = current_user.publishers.new(publisher_params)
    if @publisher.save
      render json: @publisher
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  private

  def publisher_params
    params.permit(:name)
  end
end
