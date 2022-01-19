class Api::V1::PublishersController < Api::BaseController
  include Api::V1::Docs::PublishersDoc

  validate_role roles: ['artist']

  before_action :set_publisher, only: %i[update destroy]

  param_group :doc_publishers
  def index
    @publishers = current_user.publishers.ordered.pagination(pagination_params)
    render json: @publishers, meta: { count: @publishers.count }, adapter: :json
  end

  param_group :doc_create_publishers
  def create
    byebug
    @publisher = Publisher.find_or_initialize_by(name: params[:name].upcase.delete(' '))
    @publisher.publisher_users << current_user.publisher_users.new(publisher_user_params)

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
    params.permit(:name)
  end

  def publisher_user_params
    params.require(:publisher_users_attributes).permit(:ipi, :pro, :user_id)
  end

  def set_publisher
    @publisher = current_user.publishers.find(params[:id])
  end
end
