class Api::V1::PublishersController < Api::BaseController
  validate_role roles: ['artist']

  before_action :set_name, only: %i[create update]
  before_action :set_publisher, only: %i[create update destroy]

  def index
    @publishers = current_user.publishers.ordered.pagination(pagination_params)
    render json: @publishers, meta: { count: @publishers.count }, adapter: :json
  end

  def create
    @publisher = initialize_publisher

    if @publisher.save
      render json: current_user.publishers.includes(:publisher_users).ordered
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  def update
    if @publisher.update(update_publisher_params)
      render json: current_user.publishers.includes(:publisher_users).ordered
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error creating publisher.')
    end
  end

  def destroy
    if @publisher.destroy
      render json: current_user.publishers
    else
      raise ExceptionHandler::ValidationError.new(@publisher.errors.to_h, 'Error deleting collaborator.')
    end
  end

  private

  def initialize_publisher
    return current_user.publishers.new(publisher_params) if @publisher.blank?

    @publisher.assign_attributes(publisher_params.except(:name))
    @publisher
  end

  def publisher_params
    parse_publisher_user_params
    @publisher_params = params.permit(:name, publisher_users_attributes: [:ipi, :pro])

    @publisher_params[:publisher_users_attributes].each do |publisher_params|
      publisher_params.merge!(user_id: current_user.id)
    end

    @publisher_params
  end

  def update_publisher_params
    parse_publisher_user_params
    @publisher_params = params.permit(:name, :id, publisher_users_attributes: [:id, :ipi, :pro])

    @publisher_params
  end

  def parse_publisher_user_params
    begin
      params[:publisher_users_attributes] = JSON.parse(params[:publisher_users_attributes])
    rescue JSON::ParseError => e
      render status: 400, json: { errors: e.message }
    end
  end

  def set_publisher
    @publisher = current_user.publishers.find_by(id: params[:id]) || Publisher.find_by(name: params[:name])
  end

  def set_name
    params[:name] = params[:name].delete(' ').upcase
  end
end
