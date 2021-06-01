class Api::V1::PublishersController < Api::BaseController
  include UserValidator
  include RolesValidator
  include Api::V1::Docs::PublishersDoc

  validate_role roles: ['artist']

  before_action :set_publisher, only: %i[update]

  param_group :doc_publishers
  def index
    render json: current_user.publishers.ordered
  end

  param_group :doc_create_publishers
  def create
    @publisher = current_user.publishers.new(publisher_params)
    if @publisher.save
      render json: current_user.publishers.ordered
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  param_group :doc_update_publishers
  def update
    if @publisher.update(publisher_params)
      render json: current_user.publishers.ordered
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  private

  def publisher_params
    params.permit(:name)
  end

  def set_publisher
    @publisher = current_user.publishers.find(params[:id])
  end
end
