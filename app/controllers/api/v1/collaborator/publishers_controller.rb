class Api::V1::Collaborator::PublishersController < Api::V1::Collaborator::BaseController
  allow_access roles: ['collaborator'], access: %w[read write], only: %i[index]
  allow_access roles: ['collaborator'], access: %w[write], only: %i[create update destroy]

  before_action :set_publisher, only: %i[update destroy]

  def index
    @publishers = @current_artist.publishers.ordered.pagination(pagination_params)
    render json: @publishers, meta: { count: @publishers.count }, each_serializer: Api::V1::PublisherSerializer, adapter: :json
  end

  def create
    @publisher = @current_artist.publishers.new(publisher_params)
    if @publisher.save
      render json: @current_artist.publishers.ordered, each_serializer: Api::V1::PublisherSerializer
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  def update
    if @publisher.update(publisher_params)
      render json: @current_artist.publishers.ordered, each_serializer: Api::V1::PublisherSerializer
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  def destroy
    if @publisher.destroy
      render json: @current_artist.publishers, each_serializer: Api::V1::PublisherSerializer
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error deleting collaborator.')
    end
  end

  private

  def publisher_params
    params.permit(:name, :pro, :ipi)
  end

  def set_publisher
    @publisher = @current_artist.publishers.find(params[:id])
  end
end
