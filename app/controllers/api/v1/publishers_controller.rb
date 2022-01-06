class Api::V1::PublishersController < Api::BaseController
  include Api::V1::Docs::PublishersDoc

  validate_role roles: ['artist']

  before_action :set_publisher, only: %i[update destroy]
  before_action :set_name, only: %i[create update]

  param_group :doc_publishers
  def index
    @publishers = current_user.publishers.ordered.pagination(pagination_params)
    render json: @publishers, meta: { count: @publishers.count }, adapter: :json
  end

  param_group :doc_create_publishers
  def create
    @publisher = Publisher.find_by(name: params[:name])
    @publisher = @publisher.present? ? create_publisher_user : current_user.publishers.new(publisher_params)
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

  def create_publisher_user
    @publisher.update(publisher_user_params)
    @publisher
  end

  def publisher_params
    params.permit(:name, publisher_users_attributes: [:ipi, :pro, :user_id])
  end

  def publisher_user_params
     params.permit(publisher_users_attributes: [:ipi, :pro, :user_id])
  end

  def set_publisher
    @publisher = current_user.publishers.find(params[:id])
  end

  def set_name
    params[:name] = params[:name].delete(' ').upcase
  end
end
