class Api::V1::PublishersController < Api::BaseController
  include Api::V1::Docs::PublishersDoc

  validate_role roles: ['artist']

  before_action :set_publisher, only: %i[update destroy]

  param_group :doc_publishers
  def index
    render json: current_user.publishers.ordered.pagination(pagination_params)
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

  param_group :doc_destroy_publisher
  def destroy
    if @publisher.destroy
      render json: current_user.publishers
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error deleting collaborator.')
    end
  end

  private

  def publisher_params
    params.permit(:name, :pro, :ipi)
  end

  def set_publisher
    @publisher = current_user.publishers.find(params[:id])
  end
end
